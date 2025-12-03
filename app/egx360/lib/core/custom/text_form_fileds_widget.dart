import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 🔹 Generic Text Field Widget (uses solid background color from theme)
Widget textFieldWidget({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  String? Function(String?)? validator,
  TextInputType inputType = TextInputType.text,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: colorScheme.onSurface.withOpacity(0.8)),
          hintText: hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          filled: true,
          fillColor: colorScheme.surface, // ✅ خلفية غير شفافة
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.error),
          ),
        ),
      );
    },
  );
}

/// 🔹 Password Text Field Widget (uses solid background color from theme)
Widget textFieldPasswordWidget({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  required RxBool isObsure,
  String? Function(String?)? validator,
  TextInputType inputType = TextInputType.visiblePassword,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Obx(
        () => TextFormField(
          controller: controller,
          keyboardType: inputType,
          obscureText: isObsure.value,
          validator: validator,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
            hintText: hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            filled: true,
            fillColor: colorScheme.surface, // ✅ خلفية واضحة من الثيم
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error),
            ),

            // 🔹 زر إظهار/إخفاء كلمة المرور
            suffixIcon: IconButton(
              icon: Icon(
                isObsure.value ? Icons.visibility_off : Icons.visibility,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              onPressed: () => isObsure.value = !isObsure.value,
            ),
          ),
        ),
      );
    },
  );
}
