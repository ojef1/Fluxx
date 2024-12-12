import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';

class ToggleStatus extends StatefulWidget {
  final Function(int value) isPayed;
  final int initialValue;
  const ToggleStatus(
      {super.key, required this.isPayed, required this.initialValue});

  @override
  State<ToggleStatus> createState() => _ToggleStatusState();
}

class _ToggleStatusState extends State<ToggleStatus> {
  late bool _isPayed;

  @override
  void initState() {
     _isPayed = intToBool(widget.initialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .03),
      width: mediaQuery.width * .35,
      height: mediaQuery.height * .1,
      decoration: BoxDecoration(
        gradient: AppTheme.colors.primaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: _isPayed
                  ? const LinearGradient(colors: [Colors.green, Colors.green])
                  : const LinearGradient(colors: [Colors.white, Colors.white]),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(2, 2), blurRadius: 5),
              ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isPayed = true;
                });
                widget.isPayed(1);
              },
              icon: Icon(
                Icons.check,
                color: _isPayed ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: !_isPayed
                  ? const LinearGradient(colors: [Colors.red, Colors.red])
                  : const LinearGradient(colors: [Colors.white, Colors.white]),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(2, 2), blurRadius: 5),
              ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isPayed = false;
                });
                widget.isPayed(0);
              },
              icon: Icon(
                Icons.close,
                color: !_isPayed ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
