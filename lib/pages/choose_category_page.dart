import 'package:Fluxx/components/animated_check_button.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChooseCategoryPage extends StatefulWidget {
  const ChooseCategoryPage({super.key});

  @override
  State<ChooseCategoryPage> createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric( horizontal: mediaQuery.width * .05,),
            child: Column(
              children: [
                //AppBar
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: Constants.topMargin),
                  
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.colors.grayD4,
                        child: IconButton(
                            color: Colors.black,
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_rounded)),
                      ),
                      SizedBox(width: mediaQuery.width * .1),
                      Text(
                        'Escolher Categoria',
                        style: AppTheme.textStyles.titleTextStyle,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Categoria Selecionada : {categoria}',
                  style: AppTheme.textStyles.subTileTextStyle,
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: mediaQuery.width * .05,
                    bottom: mediaQuery.width * .01,
                    left: mediaQuery.width * .05,
                    right: mediaQuery.width * .05,
                  ),
                  height: 1,
                  color: Colors.white,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: AnimatedCheckButton(text: 'categoria $index'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
