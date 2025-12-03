import 'dart:io';
import 'package:egx/core/errors/app_exception.dart';
import 'package:egx/core/services/network_service.dart';
import 'package:egx/features/auth/data/model/auth_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RemoteAuthDatasource {
  Future<AuthModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthModel> signIn({required String email, required String password});

  Future<bool> isEmailVerified();

  Future<void> resetPassword(String email);

  Future<void> updatePassword(String newPassword);

  Future<void> updateUserData(AuthModel user);

  Future<AuthModel> googleSignIN();

  bool get isLoggedIn;

  Future<void> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  });

  Future<void> logout();

  Future<void> deleteAccount(String userId);
}

class RemoteAuthDatasourceImpl implements RemoteAuthDatasource {
  final supabase = Supabase.instance.client;

  // Sign Up
  @override
  Future<AuthModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
        emailRedirectTo: 'io.supabase.flutter://login-callback/',
      );

      if (res.user != null) {
        final identities = res.user!.identities;
        if (identities == null || identities.isEmpty) {
          throw const UserAlreadyExistsException('User already registered');
        }
        if (res.user!.emailConfirmedAt != null) {
          throw const UserAlreadyExistsException('User already registered');
        }

        final data = AuthModel(
          id: res.user!.id,
          name: name,
          email: email,
          avatarUrl: '',
          lastActiveAtDate: DateTime.now(),
        );
        //
        await supabase.from('profiles').insert(data.toMap());
        return data;
      } else {
        throw const AuthAppException(
          'Signup failed - no user created',
          'signup_failed',
        );
      }
    } on UserAlreadyExistsException {
      rethrow;
    } on AuthApiException catch (e) {
      if (e.code == 'user_already_exists' ||
          e.code == 'email_exists' ||
          e.message.toLowerCase().contains('already registered') ||
          e.message.toLowerCase().contains('duplicate') ||
          e.statusCode == 409 ||
          e.statusCode == 422) {
        throw const UserAlreadyExistsException('User already registered');
      }
      throw AuthAppException(e.message, e.code);
    } on SocketException {
      throw const NetworkAppException('No internet connection.');
    } catch (e) {
      print(e);
      throw AuthAppException('Unexpected error: ${e.toString()}');
    }
  }

  // Sign In
  @override
  Future<AuthModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final profileResponse = await supabase
          .from('profiles')
          .select('*')
          .eq('id', res.user!.id)
          .maybeSingle();
      if (profileResponse == null) {
        throw const MissingDataException('Profile not found.');
      }

      final data = AuthModel.fromMap(
        profileResponse,
      ).copyWith(lastActiveAtDate: DateTime.now());

      await supabase
          .from('profiles')
          .update({'last_active_at': data.lastActiveAt?.toString()})
          .eq('id', res.user!.id);
      //

      return data;
    } on AuthApiException catch (e) {
      if (e.code == 'invalid_credentials' ||
          e.statusCode == 400 ||
          e.message.toLowerCase().contains('invalid login credentials')) {
        throw const MissingDataException('Invalid login credentials');
      }
      throw AuthAppException(e.message, e.code);
    } on SocketException {
      throw const NetworkAppException('No internet connection.');
    } catch (e) {
      print(e);
      throw AuthAppException('Unexpected error: ${e.toString()}');
    }
  }

  // Check Email Verification
  @override
  Future<bool> isEmailVerified() async {
    await supabase.auth.refreshSession();
    final user = supabase.auth.currentUser;
    if (user == null) return false;
    return user.emailConfirmedAt != null;
  }

  // Reset Password (Send Email)
  @override
  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-password/',
      );
    } on AuthApiException catch (e) {
      if (e.code == 'invalid_credentials' ||
          e.statusCode == 400 ||
          e.message.toLowerCase().contains('invalid login credentials') ||
          e.message.toLowerCase().contains('email not found')) {
        throw const UserNotFoundException('No account found for this email.');
      }
      throw AuthAppException(e.message, e.code);
    } on SocketException {
      throw const NetworkAppException('No internet connection.');
    } catch (e) {
      throw const AuthAppException('Something went wrong. Please try again.');
    }
  }

  // Update Password (After Reset Link)
  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthApiException catch (e) {
      throw AuthAppException(e.message, e.code);
    } on SocketException {
      throw const NetworkAppException('No internet connection.');
    } catch (e) {
      print(e);
      throw const AuthAppException('Unexpected error while updating password.');
    }
  }

  // google signIN
  @override
  Future<AuthModel> googleSignIN() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        clientId: dotenv.env['CLIENT_ID']!,
        serverClientId: dotenv.env['SERVER_CLIENT_ID']!,
      );

      //  use nullable type
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      // CANCELLATION CHECK
      if (googleUser == null) {
        throw const GoogleSignInCancelledException();
      }

      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw const AuthAppException(
          'Google Sign-In failed: Missing ID Token.',
        );
      }

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final user = response.user;

      if (user == null || response.session == null) {
        throw const AuthAppException(
          'Google sign-in failed: No session created.',
        );
      }

      final String avatarUrl =
          googleUser.photoUrl ??
          user.userMetadata?['avatar_url'] ??
          user.userMetadata?['picture'] ??
          '';

      // get profile
      final profileResponse = await supabase
          .from('profiles')
          .select('*')
          .eq('id', user.id)
          .maybeSingle();

      late AuthModel userProfile;

      if (profileResponse == null) {
        userProfile = AuthModel(
          id: user.id,
          name: user.userMetadata?['name'] ?? user.email ?? '',
          email: user.email ?? '',
          avatarUrl: avatarUrl,
          bio: '',
          lastActiveAtDate: DateTime.now(),
          createdAtDate: DateTime.now(),
          updatedAtDate: DateTime.now(),
        );

        await supabase.from('profiles').insert(userProfile.toMap());
      } else {
        await supabase
            .from('profiles')
            .update({'last_active_at': DateTime.now().toIso8601String()})
            .eq('id', user.id);

        final updatedProfile = await supabase
            .from('profiles')
            .select('*')
            .eq('id', user.id)
            .maybeSingle();

        userProfile = AuthModel.fromMap(
          updatedProfile ?? profileResponse,
        ).copyWith(lastActiveAtDate: DateTime.now());
      }

      return userProfile;
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        throw const GoogleSignInCancelledException();
      }
      throw AuthAppException(e.message ?? 'Google Sign-In failed');
    } on SocketException {
      throw const NetworkAppException('No internet connection.');
    } catch (e) {
      if (e.toString().toLowerCase().contains('canceled') ||
          e.toString().toLowerCase().contains('cancelled')) {
        throw const GoogleSignInCancelledException();
      }

      throw AuthAppException('Unexpected error during Google Sign-In: $e');
    }
  }

  // Check if logged in before
  @override
  bool get isLoggedIn => supabase.auth.currentUser != null;

  // Update User Data
  @override
  Future<void> updateUserData(AuthModel user) async {
    try {
      await supabase.from('profiles').update(user.toMap()).eq('id', user.id);
    } on SocketException {
      throw const NetworkAppException('No internet connection.');
    } catch (e) {
      throw AuthAppException('Failed to update profile: $e');
    }
  }

  // Change Password
  @override
  Future<void> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    if (!await NetworkService.isConnected) {
      throw const NetworkAppException('No internet connection.');
    }

    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: oldPassword,
      );
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        throw const AuthInvalidCredentialsException('Incorrect old password.');
      }
      throw AuthAppException(e.message);
    }

    await supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  // Logout
  @override
  Future<void> logout() async {
    if (!await NetworkService.isConnected) {
      throw const NetworkAppException('No internet connection.');
    }

    try {
      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthAppException('Logout failed: ${e.message}');
    } catch (e) {
      throw UserNotFoundException('Unexpected error during logout: $e');
    }
  }

  final supabaseAdmin = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_SERVICEROLE']!,
  );

  // Delete Account
  @override
  Future<void> deleteAccount(String userId) async {
    if (!await NetworkService.isConnected) {
      throw const NetworkAppException('No internet connection.');
    }

    try {
      // Delete profile data
      await supabase.from('profiles').delete().eq('id', userId);
      await supabaseAdmin.auth.admin.deleteUser(userId);

      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthAppException(e.message);
    } catch (e) {
      throw UserNotFoundException('Failed to delete account: $e');
    }
  }
}
