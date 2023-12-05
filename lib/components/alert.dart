import 'package:christmas/components/app_colors.dart';
import 'package:christmas/components/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final String message;
  final double alertWidth = 400;

  const CustomAlert({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: alertWidth,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
                top: -40.0, // Adjust this value as needed
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 75.0, // Set the width of the circle
                      height: 75.0, // Set the height of the circle
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Lottie.asset(
                        'assets/santasleigh.json',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  title,
                  style: AppTextStyles.alertTitle,
                ),
                const SizedBox(height: 8.0),
                Text(
                  message,
                  style: AppTextStyles.alertText,
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Ok",
                    style: AppTextStyles.alertButtonText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
