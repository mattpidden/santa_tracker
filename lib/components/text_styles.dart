import 'package:christmas/components/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // Styles for static text
  static const TextStyle pageTitle = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14.0,
    color: AppColors.textColor,
  );

  static const TextStyle boldBodyText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );

  static const TextStyle successText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.successColor,
  );

  static const TextStyle warningText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.warningColor,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.errorColor,
  );

  static const TextStyle activeText = TextStyle(
    fontSize: 14.0,
    color: AppColors.accentColor,
  );

  // Styles for user inputs
  static const TextStyle textFieldText = TextStyle(
    fontSize: 16.0,
    color: AppColors.primaryColor,
  );

  static const TextStyle textFieldHintText = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 16.0,
    color: AppColors.subtleTextColor,
  );

  static const TextStyle textFieldCaptionText = TextStyle(
    fontSize: 12.0,
    color: AppColors.textColor,
  );

  static const TextStyle captionButtonText = TextStyle(
    fontSize: 12.0,
    color: AppColors.accentColor,
  );

  static const TextStyle saveButtonText = TextStyle(
    fontSize: 16.0,
    color: AppColors.secondaryTextColor,
  );

  // Styles for alerts
  static const TextStyle alertTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: AppColors.textColor,
  );

  static const TextStyle alertText = TextStyle(
    fontSize: 12.0,
    color: AppColors.textColor,
  );

  static const TextStyle alertButtonText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.red,
  );
}
