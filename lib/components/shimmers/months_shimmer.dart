import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MonthsShimmer extends StatelessWidget {
  const MonthsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: mediaQuery.width * .9,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: mediaQuery.height * .01,
                horizontal: mediaQuery.width * .05,
              ),
              padding: EdgeInsets.symmetric(
                vertical: mediaQuery.height * .01,
                horizontal: mediaQuery.width * .05,
              ),
              width: mediaQuery.width * .7,
              height: mediaQuery.height * .2,
              decoration: BoxDecoration(
                color: AppTheme.colors.itemBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black, blurRadius: 2, offset: Offset(3, 3))
                ],
                border: Border(
                  left: BorderSide(
                    color: AppTheme.colors.hintColor,
                    width: 10,
                  ),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
