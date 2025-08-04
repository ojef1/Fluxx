import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';

class EmptyBillList extends StatelessWidget {
  final Function() onPressed;
  const EmptyBillList({super.key, required this.onPressed});

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
                'Parece que você não possui contas',
                style: AppTheme.textStyles.subTileTextStyle
                    .copyWith(fontSize: AppTheme.fontSizes.small),
              ),
              Image.asset(
                'assets/images/empty_bill.png',
                height: 200,
              ),
      
              Text(
                maxLines: 3,
                textAlign: TextAlign.center,
                'Crie uma em "Adicionar"',
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
