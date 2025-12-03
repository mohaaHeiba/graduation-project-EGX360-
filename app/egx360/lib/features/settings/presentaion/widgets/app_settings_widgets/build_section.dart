import 'package:egx/core/constants/app_gaps.dart';
import 'package:flutter/material.dart';

Widget buildSection(String title, String content, {required ThemeData theme}) {
  final titleColor = theme.textTheme.titleMedium?.color ?? Colors.white;
  final contentColor =
      theme.textTheme.bodyMedium?.color ?? Colors.grey.shade300;

  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppGaps.h8,
        Text(content, style: TextStyle(color: contentColor, height: 1.5)),
      ],
    ),
  );
}
