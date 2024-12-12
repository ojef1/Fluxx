
import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function() function;
  const ProfileItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.function});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: function,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: mediaQuery.width * .04,
          vertical: mediaQuery.width * .01,
        ),
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.height * .01),
        decoration: BoxDecoration(
          gradient: AppTheme.colors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        height: mediaQuery.height * .09,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                ),
                const SizedBox(width: 20),
                Text(
                  label,
                  style: AppTheme.textStyles.bodyTextStyle,
                ),
              ],
            ),
            const Icon(
              Icons.navigate_next_rounded,
              size: 30,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
