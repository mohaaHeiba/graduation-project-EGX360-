import 'package:egx/core/constants/app_gaps.dart';
import 'package:egx/core/helper/context_extensions.dart';
import 'package:flutter/material.dart';

class ModernSettingsSection extends StatelessWidget {
  final String title;
  final List<SettingItem> items;

  const ModernSettingsSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: theme.textStyles.labelSmall?.copyWith(
              color: theme.onBackground.withOpacity(0.6),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: theme.colors.shadow.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return _buildSettingTile(context, entry.value, isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    SettingItem item,
    bool isLast,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: item.onTap ?? () {},
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(10))
          : BorderRadius.zero,
      child: Container(
        decoration: BoxDecoration(
          gradient: item.gradient,
          border: !isLast
              ? Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (item.icon != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (item.iconColor ?? colorScheme.primary).withOpacity(
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  color: item.iconColor ?? colorScheme.primary,
                  size: 20,
                ),
              ),
            AppGaps.w14,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: textTheme.titleMedium?.copyWith(
                      color: item.titleColor ?? colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      item.subtitle!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            item.trailing ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.onSurface.withOpacity(0.5),
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }
}

class SettingItem {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? titleColor;
  final Color? iconColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  SettingItem({
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleColor,
    this.iconColor,
    this.gradient,
    this.onTap,
  });
}
