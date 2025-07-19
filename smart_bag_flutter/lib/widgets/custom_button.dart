import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool outlined;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.icon,
    this.padding,
    this.borderRadius,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? 
        (outlined ? Colors.transparent : AppColors.primaryBlue);
    final effectiveTextColor = textColor ?? 
        (outlined ? AppColors.primaryBlue : Colors.white);
    final effectivePadding = padding ?? 
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    final effectiveBorderRadius = borderRadius ?? 
        BorderRadius.circular(12);

    return SizedBox(
      width: width,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveTextColor,
          elevation: outlined ? 0 : 4,
          shadowColor: outlined ? Colors.transparent : 
              AppColors.primaryBlue.withOpacity(0.4),
          padding: effectivePadding,
          shape: RoundedRectangleBorder(
            borderRadius: effectiveBorderRadius,
            side: outlined ? const BorderSide(
              color: AppColors.primaryBlue,
              width: 1.5,
            ) : BorderSide.none,
          ),
          disabledBackgroundColor: outlined ? Colors.transparent : 
              AppColors.primaryBlue.withOpacity(0.6),
          disabledForegroundColor: outlined ? 
              AppColors.primaryBlue.withOpacity(0.6) : 
              Colors.white.withOpacity(0.7),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    outlined ? AppColors.primaryBlue : Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize ?? 16,
                      fontWeight: fontWeight ?? FontWeight.w600,
                      color: effectiveTextColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final double? padding;
  final BorderRadius? borderRadius;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? 24;
    final effectivePadding = padding ?? 12;
    final effectiveColor = color ?? AppColors.primaryBlue;
    final effectiveBackgroundColor = backgroundColor ?? Colors.white;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(8);

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: effectiveBorderRadius,
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(effectivePadding),
            child: Icon(
              icon,
              size: effectiveSize,
              color: effectiveColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? size;
  final bool mini;

  const CustomFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.size,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? AppColors.primaryBlue,
      foregroundColor: foregroundColor ?? Colors.white,
      mini: mini,
      elevation: 6,
      child: Icon(
        icon,
        size: size ?? (mini ? 20 : 24),
      ),
    );
  }
}