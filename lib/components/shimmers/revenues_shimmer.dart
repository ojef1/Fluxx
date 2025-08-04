import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RevenuesShimmer extends StatelessWidget {
  const RevenuesShimmer({super.key});

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
              padding: const EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(
                horizontal: mediaQuery.width * .02,
                vertical: mediaQuery.height * .01,
              ),
              height: mediaQuery.height * .12,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }
}
