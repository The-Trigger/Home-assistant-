import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool filled;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.filled = true,
    this.fillColor,
    this.borderRadius,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final effectiveFillColor = fillColor ?? Colors.white;
    final effectiveContentPadding = contentPadding ?? 
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        filled: filled,
        fillColor: effectiveFillColor,
        prefixIcon: prefixIcon != null 
            ? Icon(
                prefixIcon,
                color: AppColors.textSecondary,
                size: 20,
              )
            : null,
        suffixIcon: suffixIcon,
        contentPadding: effectiveContentPadding,
        border: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: const BorderSide(
            color: AppColors.lightGray,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: const BorderSide(
            color: AppColors.lightGray,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: effectiveBorderRadius,
          borderSide: BorderSide(
            color: AppColors.lightGray.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: AppColors.textSecondary.withOpacity(0.7),
          fontSize: 16,
        ),
        helperStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
        ),
        counterStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;

  const SearchTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onClear,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText ?? 'Search...',
      prefixIcon: FontAwesomeIcons.magnifyingGlass,
      onChanged: onChanged,
      suffixIcon: showClearButton && 
          controller != null && 
          controller!.text.isNotEmpty
          ? IconButton(
              icon: const Icon(
                FontAwesomeIcons.xmark,
                size: 16,
              ),
              onPressed: () {
                controller!.clear();
                onClear?.call();
              },
            )
          : null,
    );
  }
}

class PhoneNumberTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  const PhoneNumberTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: labelText ?? 'Phone Number',
      hintText: hintText ?? '+1234567890',
      keyboardType: TextInputType.phone,
      prefixIcon: FontAwesomeIcons.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[+\-0-9\s\(\)]')),
        LengthLimitingTextInputFormatter(15),
      ],
      validator: validator ?? _defaultPhoneValidator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  String? _defaultPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    
    // Remove all non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    
    if (digitsOnly.length > 15) {
      return 'Phone number cannot exceed 15 digits';
    }
    
    return null;
  }
}

class PinTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool showVisibilityToggle;

  const PinTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.showVisibilityToggle = true,
  });

  @override
  State<PinTextField> createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      labelText: widget.labelText ?? 'PIN',
      hintText: widget.hintText ?? 'Enter 4-8 digit PIN',
      obscureText: _obscureText,
      keyboardType: TextInputType.number,
      prefixIcon: FontAwesomeIcons.lock,
      suffixIcon: widget.showVisibilityToggle
          ? IconButton(
              icon: Icon(
                _obscureText 
                    ? FontAwesomeIcons.eyeSlash 
                    : FontAwesomeIcons.eye,
                size: 16,
              ),
              onPressed: _toggleVisibility,
            )
          : null,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      validator: widget.validator ?? _defaultPinValidator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }

  String? _defaultPinValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a PIN';
    }
    
    if (value.length < 4) {
      return 'PIN must be at least 4 digits';
    }
    
    if (value.length > 8) {
      return 'PIN cannot exceed 8 digits';
    }
    
    return null;
  }
}