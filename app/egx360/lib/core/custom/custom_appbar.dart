import 'package:flutter/material.dart';
import 'package:get/get.dart';

PreferredSizeWidget customAppbar(final VoidCallback backm, String title) {
  return AppBar(
    toolbarHeight: 80,
    backgroundColor: Theme.of(Get.context!).colorScheme.background,
    elevation: 0,
    leadingWidth: 80,
    leading: Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Center(
          child: Container(
            margin: const EdgeInsets.only(left: 0.0),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: backm,
            ),
          ),
        );
      },
    ),
    title: Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Text(
          title,
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );
}
