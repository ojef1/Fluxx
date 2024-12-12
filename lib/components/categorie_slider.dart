import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';

class CategorieSlider extends StatelessWidget {
  final List<String> filters;
  final int initialPage;
  final Function(int value) function;
  const CategorieSlider({super.key, required this.filters, required this.initialPage, required this.function});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: 5,
        itemBuilder: (context, index, realIndex) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  gradient: AppTheme.colors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Constants.categoriesIcons[filters[index]],
                  size: 100,
                  color: Colors.white,
                ),
              ),
              Text(
                filters[index],
                textAlign: TextAlign.center,
                style: AppTheme.textStyles.titleTextStyle,
              )
            ],
          );
        },
        options: CarouselOptions(
          initialPage: initialPage,
          height: 300,
          viewportFraction: 0.55,
          enlargeCenterPage: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(seconds: 2),
          onPageChanged: (index, reason) => function(index),
        ),
      ),
    );
  }
}
