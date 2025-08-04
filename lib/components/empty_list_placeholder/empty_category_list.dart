import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class EmptyCategoryList extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final String subTitle;
  const EmptyCategoryList({super.key, required this.onPressed, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Column(
            children: [
              Text(
                maxLines: 3,
                textAlign: TextAlign.center,
                title,
                style: AppTheme.textStyles.subTileTextStyle
                    .copyWith(fontSize: AppTheme.fontSizes.small),
              ),
              Image.asset(
                'assets/images/empty_category.png',
                height: 200,
              ),
      
              Text(
                maxLines: 3,
                textAlign: TextAlign.center,
                subTitle,
                style: AppTheme.textStyles.subTileTextStyle
                    .copyWith(fontSize: AppTheme.fontSizes.small),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
