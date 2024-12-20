import 'package:Fluxx/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FilterBottomsheet extends StatelessWidget {
  const FilterBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * .8,
      width: mediaQuery.width,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Container(
            height: 10,
            width: 50,
            decoration: BoxDecoration(
                color: AppTheme.colors.accentColor,
                borderRadius: BorderRadius.circular(25)),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filtrar por ', style: AppTheme.textStyles.subTileTextStyle),
              ToggleSwitch(
                minWidth: 90.0,
                animate: true,
                cornerRadius: 20.0,
                animationDuration: 300,
                radiusStyle: true,
                initialLabelIndex: 0,
                activeBgColor: const [Colors.white],
                activeFgColor: Colors.black,
                inactiveBgColor: AppTheme.colors.accentColor,
                inactiveFgColor: Colors.white,
                totalSwitches: 3,
                labels: const ['Status', 'Categoria', 'Renda'],
                onToggle: (index) {
                  print('switched to: $index');
                },
              ),
            ],
          ),
          Flexible(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return ChoiceChip(
                  label: Text('opção $index'),
                  selected: false,
                  onSelected: (isSelected) {},
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ordenar por ', style: AppTheme.textStyles.subTileTextStyle),
              ToggleSwitch(
                minWidth: 90.0,
                animate: true,
                cornerRadius: 20.0,
                animationDuration: 300,
                radiusStyle: true,
                initialLabelIndex: 0,
                activeBgColor: const [Colors.white],
                activeFgColor: Colors.black,
                inactiveBgColor: AppTheme.colors.accentColor,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const ['Valor', 'Data'],
                onToggle: (index) {
                  print('switched to: $index');
                },
              ),
            ],
          ),
          Flexible(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return ChoiceChip(
                  label: Text('opção $index'),
                  selected: false,
                  onSelected: (isSelected) {},
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Limpar Filtros',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: AppTheme.fontSizes.medium,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'Mulish',
                      decoration: TextDecoration.underline),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colors.accentColor,
                  minimumSize: const Size(50, 50),
                ),
                child: Text('Pesquisar', style: AppTheme.textStyles.bodyTextStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
