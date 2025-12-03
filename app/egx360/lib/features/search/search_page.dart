import 'package:egx/core/bindings/stock_chat_binding.dart';
import 'package:egx/core/constants/app_colors.dart';
import 'package:egx/features/search/SearchStocksController.dart';
import 'package:egx/features/stock_chat/presentation/pages/stock_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  // دالة الشرح المؤقتة: لعرض الشرح قبل الانتقال للشات
  void _showStockDescription(Map<String, dynamic> stock) {
    // بناء وصف بسيط
    String description =
        "الاسم الكامل: ${stock['company_name_ar'] ?? stock['company_name_en']}\n"
        "القطاع: ${stock['sector'] ?? 'غير محدد'}\n"
        "رمز ISIN: ${stock['isin_code'] ?? 'غير متوفر'}\n"
        "تاريخ الإدراج: ${stock['listing_date'] ?? 'غير متوفر'}\n";

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          stock['symbol'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          description,
          style: TextStyle(color: Colors.grey[300], height: 1.5),
        ),
        actions: [
          // زر الانتقال للشات
          TextButton(
            onPressed: () {
              Get.back(); // قفل الـ AlertDialog
              Get.to(
                () => const StockChatPage(),
                binding: StockChatBinding(),
                arguments: {
                  'stock_id': stock['id'],
                  'stock_name': stock['symbol'],
                },
              );
            },
            child: const Text(
              'اذهب للشات 💬',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          // زر الإغلاق
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'إغلاق',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchStocksController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text("بحث عن سهم", style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. حقل البحث
              TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'ابحث باسم الشركة أو الرمز (مثلاً: TMGH)',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. قائمة النتائج أو العرض المبدئي
              Expanded(
                child: Obx(() {
                  final bool isSearching =
                      controller.searchController.text.isNotEmpty;
                  final currentList = isSearching
                      ? controller.searchResults
                      : controller.initialPicks;

                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (currentList.isEmpty && isSearching) {
                    return const Center(
                      child: Text(
                        "لا توجد نتائج",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  // العنوان عند عدم وجود بحث
                  if (currentList.isNotEmpty && !isSearching) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "⭐ الأسهم المقترحة",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          // GridView للعرض الجذاب عند البداية
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // عمودين
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.5, // نسبة العرض للارتفاع
                                ),
                            itemCount: currentList.length,
                            itemBuilder: (context, index) {
                              final stock = currentList[index];
                              return _buildStockGridItem(
                                stock,
                                _showStockDescription,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  // العرض عند البحث
                  return ListView.builder(
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      final stock = currentList[index];
                      return _buildStockListItem(stock, _showStockDescription);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// الدوال المساعدة لتحسين الشكل
// -----------------------------------------------------------------------------

// تصميم العنصر في شكل قائمة (يستخدم عند البحث)
Widget _buildStockListItem(
  Map<String, dynamic> stock,
  Function(Map<String, dynamic>) onTap,
) {
  return Card(
    color: Colors.grey[850],
    margin: const EdgeInsets.only(bottom: 8),
    elevation: 3,
    child: ListTile(
      onTap: () => onTap(stock),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.blueGrey,
        backgroundImage: stock['logo_url'] != null
            ? NetworkImage(stock['logo_url'])
            : null,
        child: stock['logo_url'] == null
            ? Text(
                stock['symbol'][0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        stock['symbol'],
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        stock['company_name_ar'] ?? stock['company_name_en'],
        style: TextStyle(color: Colors.grey[400]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        stock['sector'] ?? 'قطاع',
        style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
      ),
    ),
  );
}

// تصميم العنصر في شكل Grid (يستخدم للعرض الأولي)
Widget _buildStockGridItem(
  Map<String, dynamic> stock,
  Function(Map<String, dynamic>) onTap,
) {
  return GestureDetector(
    onTap: () => onTap(stock),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue,
            backgroundImage: stock['logo_url'] != null
                ? NetworkImage(stock['logo_url'])
                : null,
            child: stock['logo_url'] == null
                ? Text(
                    stock['symbol'][0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            stock['symbol'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          Text(
            stock['sector'] ?? 'قطاع',
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}
