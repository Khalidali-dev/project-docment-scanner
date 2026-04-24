import 'package:flutter/material.dart';
import '../utils/index.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;
  final Widget? icon;
  final MainAxisAlignment iconPosition;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.buttonStyle,
    this.textStyle,
    this.icon,
    this.iconPosition = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style:
          buttonStyle ??
          ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: AppDimensions.paddingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
            ),
          ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: iconPosition,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: AppDimensions.paddingS),
                ],
                Text(
                  label,
                  style:
                      textStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontSize: AppFonts.fontSize16,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputDecoration? decoration;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.decoration,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: AppFonts.fontSize14,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          maxLines: _obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration:
              widget.decoration ??
              InputDecoration(
                hintText: widget.hint,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.obscureText
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : widget.suffixIcon,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusM,
                  ),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusM,
                  ),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusM,
                  ),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingM,
                ),
              ),
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin:
            margin ??
            const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        elevation: elevation ?? AppDimensions.elevationM,
        shape: RoundedRectangleBorder(
          borderRadius:
              borderRadius ??
              BorderRadius.circular(AppDimensions.borderRadiusL),
        ),
        color: backgroundColor ?? AppColors.surface,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppDimensions.paddingM),
          child: child,
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          if (message != null) ...[
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              message!,
              style: const TextStyle(
                fontSize: AppFonts.fontSize16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyWidget({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppDimensions.iconXL, color: AppColors.textTertiary),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppFonts.fontSize18,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFonts.fontSize14,
              color: AppColors.textSecondary,
            ),
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: AppDimensions.paddingL),
            CustomButton(label: actionLabel!, onPressed: onAction!),
          ],
        ],
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: AppDimensions.iconXL,
            color: AppColors.error,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'Error',
            style: const TextStyle(
              fontSize: AppFonts.fontSize18,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFonts.fontSize14,
              color: AppColors.textSecondary,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppDimensions.paddingL),
            CustomButton(label: AppStrings.tryAgain, onPressed: onRetry!),
          ],
        ],
      ),
    );
  }
}

class SnackBarHelper {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.info,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
