import 'package:flutter/material.dart';

Widget buildSimulationCard(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  return Container(
    decoration: BoxDecoration(
      color: colorScheme.surface, // بدل Colors.grey[900]
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Header ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Simulation Portfolio',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: colorScheme.onSurface.withOpacity(0.4),
                size: 14,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ---------- Balance ----------
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'EGP',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '10,000.00',
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '+0.0%',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ---------- Stats ----------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSimStatItem(
                    context,
                    'Total P&L',
                    '+EGP 0.00',
                    colorScheme.secondary,
                    Icons.trending_up_rounded,
                  ),
                ),
                _divider(colorScheme),
                Expanded(
                  child: _buildSimStatItem(
                    context,
                    'Positions',
                    '0',
                    colorScheme.primary,
                    Icons.layers_rounded,
                  ),
                ),
                _divider(colorScheme),
                Expanded(
                  child: _buildSimStatItem(
                    context,
                    'Available Cash',
                    '10,000.00',
                    colorScheme.onSurface.withOpacity(0.7),
                    Icons.attach_money_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _divider(ColorScheme colorScheme) => Container(
  width: 1,
  height: 40,
  color: colorScheme.outline.withOpacity(0.2),
);

Widget _buildSimStatItem(
  BuildContext context,
  String label,
  String value,
  Color color,
  IconData icon,
) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;

  return Column(
    children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 8),
      Text(
        value,
        style: textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface.withOpacity(0.6),
          fontSize: 11,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
