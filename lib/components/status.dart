import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  final int isPayed;
  const Status({
    super.key,
    required this.isPayed,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.colors.primaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: CircleAvatar(
        radius: mediaQuery.width * .04,
        backgroundColor: Colors.transparent,
        child: Icon(
          isPayed == 1 ? Icons.check : Icons.close,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
