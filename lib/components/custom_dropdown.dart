import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String hint;
  final double minWidth;
  final List<String> filters;
  final Offset offset;
  final Function(String value)? function;
  final String? initialValue; 

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.minWidth,
    required this.filters,
    required this.offset,
    this.function,
    this.initialValue, 
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      height: mediaQuery.height * .06,
      decoration: BoxDecoration(
        gradient: AppTheme.colors.primaryColor,
        borderRadius: _customBorderRadius(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.hint,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          items: widget.filters.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Constants.categoriesIcons[option],
                      color: Colors.white,
                    ),
                    Expanded(
                      child: Text(
                        option,
                        textAlign: TextAlign.center,
                        style: AppTheme.textStyles.bodyTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          value: selectedValue,
          onChanged: (String? value) {
            setState(() {
              selectedValue = value;
              if (widget.function != null) {
                widget.function!(value!);
              }
            });
          },
          onMenuStateChange: (isOpen) {
            setState(() {
              isMenuOpen = isOpen;
            });
          },
          buttonStyleData: ButtonStyleData(
            width: widget.minWidth,
            padding: const EdgeInsets.only(left: 14, right: 14),
          ),
          iconStyleData: const IconStyleData(
            openMenuIcon: FittedBox(
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.white,
              ),
            ),
            icon: FittedBox(
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            elevation: 0,
            width: widget.minWidth,
            decoration: BoxDecoration(
              gradient: AppTheme.colors.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            offset: widget.offset,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }

  BorderRadiusGeometry _customBorderRadius() {
    BorderRadiusGeometry customBorderRadius = isMenuOpen
        ? const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )
        : BorderRadius.circular(50);

    return customBorderRadius;
  }
}
