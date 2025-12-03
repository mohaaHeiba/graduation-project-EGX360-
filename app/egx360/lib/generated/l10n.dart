// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  // skipped getter for the '//_APP_GLOBAL' key

  /// `EGX360`
  String get appTitle {
    return Intl.message('EGX360', name: 'appTitle', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Something went wrong.`
  String get unknown_error {
    return Intl.message(
      'Something went wrong.',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  // skipped getter for the '//_BUTTONS' key

  /// `Submit`
  String get button_submit {
    return Intl.message('Submit', name: 'button_submit', desc: '', args: []);
  }

  /// `Cancel`
  String get button_cancel {
    return Intl.message('Cancel', name: 'button_cancel', desc: '', args: []);
  }

  /// `Retry`
  String get button_retry {
    return Intl.message('Retry', name: 'button_retry', desc: '', args: []);
  }

  /// `OK`
  String get button_ok {
    return Intl.message('OK', name: 'button_ok', desc: '', args: []);
  }

  /// `Get started`
  String get get_started {
    return Intl.message('Get started', name: 'get_started', desc: '', args: []);
  }

  // skipped getter for the '//_ONBOARDING_SCREEN' key

  /// `Welcome to EGX360`
  String get welcome_title {
    return Intl.message(
      'Welcome to EGX360',
      name: 'welcome_title',
      desc: '',
      args: [],
    );
  }

  /// `Market data, charts and more — all in one place.`
  String get welcome_subtitle {
    return Intl.message(
      'Market data, charts and more — all in one place.',
      name: 'welcome_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, you agree to our Terms of Service and Privacy Policy`
  String get policy_agreement {
    return Intl.message(
      'By continuing, you agree to our Terms of Service and Privacy Policy',
      name: 'policy_agreement',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '//_AUTH_COMMON' key

  /// `Email`
  String get email_label {
    return Intl.message('Email', name: 'email_label', desc: '', args: []);
  }

  /// `Password`
  String get password_label {
    return Intl.message('Password', name: 'password_label', desc: '', args: []);
  }

  /// `Full name`
  String get name_label {
    return Intl.message('Full name', name: 'name_label', desc: '', args: []);
  }

  /// `Phone`
  String get phone_label {
    return Intl.message('Phone', name: 'phone_label', desc: '', args: []);
  }

  /// `or continue with`
  String get continue_with {
    return Intl.message(
      'or continue with',
      name: 'continue_with',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get sign_google {
    return Intl.message(
      'Sign in with Google',
      name: 'sign_google',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '//_LOGIN_SCREEN' key

  /// `Sign in`
  String get auth_sign_in {
    return Intl.message('Sign in', name: 'auth_sign_in', desc: '', args: []);
  }

  /// `Forgot password?`
  String get forgot_password {
    return Intl.message(
      'Forgot password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get register_login {
    return Intl.message('Log In', name: 'register_login', desc: '', args: []);
  }

  // skipped getter for the '//_REGISTER_SCREEN' key

  /// `Sign up`
  String get auth_sign_up {
    return Intl.message('Sign up', name: 'auth_sign_up', desc: '', args: []);
  }

  /// `Create an account`
  String get create_account {
    return Intl.message(
      'Create an account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Join us and start exploring all the amazing features we offer!`
  String get register_description {
    return Intl.message(
      'Join us and start exploring all the amazing features we offer!',
      name: 'register_description',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get register_have_account {
    return Intl.message(
      'Already have an account? ',
      name: 'register_have_account',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '//_FORGOT_PASSWORD_SCREEN' key

  /// `Enter your email below and we’ll send you a link to reset your password.`
  String get forgot_description {
    return Intl.message(
      'Enter your email below and we’ll send you a link to reset your password.',
      name: 'forgot_description',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get forgot_send_link {
    return Intl.message(
      'Send Reset Link',
      name: 'forgot_send_link',
      desc: '',
      args: [],
    );
  }

  /// `Sending...`
  String get forgot_loading {
    return Intl.message(
      'Sending...',
      name: 'forgot_loading',
      desc: '',
      args: [],
    );
  }

  /// `Remember your password? `
  String get forgot_remember {
    return Intl.message(
      'Remember your password? ',
      name: 'forgot_remember',
      desc: '',
      args: [],
    );
  }

  /// `Password reset instructions were sent if that email exists.`
  String get msg_password_reset {
    return Intl.message(
      'Password reset instructions were sent if that email exists.',
      name: 'msg_password_reset',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '//_VERIFICATION_SCREEN' key

  /// `Send code`
  String get send_code {
    return Intl.message('Send code', name: 'send_code', desc: '', args: []);
  }

  /// `Verify code`
  String get verify_code {
    return Intl.message('Verify code', name: 'verify_code', desc: '', args: []);
  }

  /// `A verification code was sent to your email.`
  String get msg_verification_sent {
    return Intl.message(
      'A verification code was sent to your email.',
      name: 'msg_verification_sent',
      desc: '',
      args: [],
    );
  }

  /// `We've sent a verification link to\n{email}`
  String email_verification_sent(Object email) {
    return Intl.message(
      'We\'ve sent a verification link to\n$email',
      name: 'email_verification_sent',
      desc: '',
      args: [email],
    );
  }

  /// `Please verify your email to continue...`
  String get email_verification_message {
    return Intl.message(
      'Please verify your email to continue...',
      name: 'email_verification_message',
      desc: '',
      args: [],
    );
  }

  /// `Verified Successfully`
  String get email_verified_success {
    return Intl.message(
      'Verified Successfully',
      name: 'email_verified_success',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '//_CREATE_NEW_PASSWORD' key

  /// `Create New Password`
  String get create_password_title {
    return Intl.message(
      'Create New Password',
      name: 'create_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Set a strong new password to secure your account.`
  String get create_password_description {
    return Intl.message(
      'Set a strong new password to secure your account.',
      name: 'create_password_description',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get create_password_new {
    return Intl.message(
      'New Password',
      name: 'create_password_new',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get create_password_confirm_new {
    return Intl.message(
      'Confirm New Password',
      name: 'create_password_confirm_new',
      desc: '',
      args: [],
    );
  }

  /// `Update Password`
  String get create_password_update_button {
    return Intl.message(
      'Update Password',
      name: 'create_password_update_button',
      desc: '',
      args: [],
    );
  }

  /// `Remembered your password? `
  String get create_password_remember {
    return Intl.message(
      'Remembered your password? ',
      name: 'create_password_remember',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '//_INPUT_PLACEHOLDERS' key

  /// `you@example.com`
  String get placeholder_email {
    return Intl.message(
      'you@example.com',
      name: 'placeholder_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get placeholder_password {
    return Intl.message(
      'Enter your password',
      name: 'placeholder_password',
      desc: '',
      args: [],
    );
  }

  /// `Your full name`
  String get placeholder_name {
    return Intl.message(
      'Your full name',
      name: 'placeholder_name',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '//_VALIDATION_ERRORS' key

  /// `This field is required.`
  String get error_required_field {
    return Intl.message(
      'This field is required.',
      name: 'error_required_field',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get error_invalid_email {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'error_invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters.`
  String get error_password_too_short {
    return Intl.message(
      'Password must be at least 6 characters.',
      name: 'error_password_too_short',
      desc: '',
      args: [],
    );
  }

  /// `Network error, please try again.`
  String get error_network {
    return Intl.message(
      'Network error, please try again.',
      name: 'error_network',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name.`
  String get enterName {
    return Intl.message(
      'Please enter your name.',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 3 characters.`
  String get nameMinChars {
    return Intl.message(
      'Name must be at least 3 characters.',
      name: 'nameMinChars',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address.`
  String get enterEmail {
    return Intl.message(
      'Please enter your email address.',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password.`
  String get enterPassword {
    return Intl.message(
      'Please enter your password.',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters.`
  String get passwordMinChars {
    return Intl.message(
      'Password must be at least 6 characters.',
      name: 'passwordMinChars',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain an uppercase letter and a number.`
  String get passwordUpperNumber {
    return Intl.message(
      'Password must contain an uppercase letter and a number.',
      name: 'passwordUpperNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password.`
  String get confirmPassword {
    return Intl.message(
      'Please confirm your password.',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get passwordsNotMatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'passwordsNotMatch',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '//_NAVIGATION_BAR' key

  /// `Home`
  String get nav_home {
    return Intl.message('Home', name: 'nav_home', desc: '', args: []);
  }

  /// `Markets`
  String get nav_markets {
    return Intl.message('Markets', name: 'nav_markets', desc: '', args: []);
  }

  /// `Search`
  String get nav_search {
    return Intl.message('Search', name: 'nav_search', desc: '', args: []);
  }

  /// `Community`
  String get nav_community {
    return Intl.message('Community', name: 'nav_community', desc: '', args: []);
  }

  /// `Menu`
  String get nav_menu {
    return Intl.message('Menu', name: 'nav_menu', desc: '', args: []);
  }

  // skipped getter for the '//_MAIN_SCREENS' key

  /// `Home`
  String get home_title {
    return Intl.message('Home', name: 'home_title', desc: '', args: []);
  }

  /// `Portfolio`
  String get portfolio_title {
    return Intl.message(
      'Portfolio',
      name: 'portfolio_title',
      desc: '',
      args: [],
    );
  }

  /// `Markets`
  String get markets_title {
    return Intl.message('Markets', name: 'markets_title', desc: '', args: []);
  }

  /// `Settings`
  String get settings_title {
    return Intl.message('Settings', name: 'settings_title', desc: '', args: []);
  }

  /// `Candlestick`
  String get chart_candlestick {
    return Intl.message(
      'Candlestick',
      name: 'chart_candlestick',
      desc: '',
      args: [],
    );
  }

  /// `Line`
  String get chart_line {
    return Intl.message('Line', name: 'chart_line', desc: '', args: []);
  }

  /// `Loading chart...`
  String get chart_loading {
    return Intl.message(
      'Loading chart...',
      name: 'chart_loading',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search_hint {
    return Intl.message('Search', name: 'search_hint', desc: '', args: []);
  }

  /// `No results found`
  String get no_results {
    return Intl.message(
      'No results found',
      name: 'no_results',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
