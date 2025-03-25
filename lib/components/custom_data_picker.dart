import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';

class CustomDataPicker extends StatefulWidget {
  final IconData icon;
  final String hint;
  final Function(String) onDateChanged;
  const CustomDataPicker({super.key, required this.icon, required this.hint, required this.onDateChanged});

  @override
  State<CustomDataPicker> createState() => _CustomDataPickerState();
}

class _CustomDataPickerState extends State<CustomDataPicker> {
  late String? formattedDate;

  @override
  void initState() {
    formattedDate = null;
    super.initState();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        formattedDate = formatDate(picked.toString());
        widget.onDateChanged(picked.toString());
        debugPrint(formattedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: mediaQuery.width * .85,
      height: mediaQuery.height * .07,
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .03),
      decoration: BoxDecoration(
        color: AppTheme.colors.accentColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            readOnly: true,
            cursorColor: Colors.white,
            onTap: () => selectDate(context),
            style: AppTheme.textStyles.bodyTextStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: formattedDate ?? widget.hint,
              hintStyle: AppTheme.textStyles.bodyTextStyle,
            ),
          )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: mediaQuery.width * .03),
            width: 1,
            color: Colors.white,
          ),
          Icon(
            widget.icon,
            color: Colors.white,
            size: 30,
          )
        ],
      ),
    );
  }
}
