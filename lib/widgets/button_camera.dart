import 'package:crypto_app/themes/app_colors.dart';
import 'package:crypto_app/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class ButtonCamera extends StatelessWidget {
  final Function onTap;
  final String text;
  final IconData icon;

  const ButtonCamera({
    Key? key,
    required this.onTap,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.label),
          borderRadius: BorderRadius.circular(10)),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 40,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: TextStyles.selection,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
