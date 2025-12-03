import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchStocksController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  // لتخزين نتائج البحث
  var searchResults = <Map<String, dynamic>>[].obs;

  // حالة التحميل
  var isLoading = false.obs;

  // للتحكم في النص
  final TextEditingController searchController = TextEditingController();

  // Debounce (مؤقت عشان ميبحثش غير لما اليوزر يبطل كتابة لمدة معينة)
  Timer? _debounce;
  final initialPicks = <Map<String, dynamic>>[].obs;

  Future<void> _fetchInitialPicks() async {
    try {
      final response = await supabase
          .from('stocks')
          .select()
          .filter('symbol', 'in', '("COMI","TMGH","FWRY","SWDY","HRHO")')
          .limit(5);

      initialPicks.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching initial picks: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // أول ما الكنترولر يشتغل، جيب أشهر الأسهم
    _fetchInitialPicks();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // استنى 500 مللي ثانية قبل ما تبدأ بحث
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        searchStocks(query);
      } else {
        searchResults.clear();
      }
    });
  }

  Future<void> searchStocks(String query) async {
    isLoading.value = true;
    try {
      // بحث شامل في الرمز والاسم العربي والإنجليزي
      final response = await supabase
          .from('stocks')
          .select()
          .or(
            'symbol.ilike.%$query%,company_name_ar.ilike.%$query%,company_name_en.ilike.%$query%',
          )
          .limit(20); // هات أول 20 نتيجة بس عشان السرعة

      searchResults.value = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      Get.snackbar('Error', 'حدث خطأ أثناء البحث');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
