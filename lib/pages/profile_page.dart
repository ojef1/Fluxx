import 'dart:io';

import 'package:Fluxx/blocs/user_cubit/user_cubit.dart';
import 'package:Fluxx/blocs/user_cubit/user_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String? versao = '';

  late final String initialName;

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile = XFile('');

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _verifyData();
  }

  void _verifyData() {
    var state = GetIt.I<UserCubit>().state;

    // Verifica se o nome foi alterado
    var nameIsDiff = nameController.text != (initialName);

    // Verifica se a imagem foi alterada
    var isDefaultPic = _pickedFile?.path == Constants.defaultPicture;
     var picIsDiff = (_pickedFile!.path.isNotEmpty &&
                   _pickedFile != null && 
                   (_pickedFile!.path != (state.user?.picture ?? '') || !isDefaultPic));

    // Se o nome ou a foto foram alterados, salva as edições
    if (nameIsDiff || picIsDiff) {
      _saveEdits(context);
    }

    return;
  }

  Future<void> _init() async {
    await GetIt.I<UserCubit>().getUserInfos();
    var version = await getVersion();
    GetIt.I<UserCubit>().udpateVersionApp(version);
    var state = GetIt.I<UserCubit>().state;
    nameController.text = state.user?.name ?? '';
    initialName = state.user?.name ?? '';
    priceController.text = state.user?.salary.toString() ?? '';
  }

  Future<void> _pickImage() async {
    _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      GetIt.I<UserCubit>().editPicture(_pickedFile!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    var screenPadding =
        EdgeInsets.symmetric(horizontal: mediaQuery.width * .04);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: AppTheme.colors.appBackgroundColor,
        appBar: const CustomAppBar(title: 'Perfil'),
        body: SafeArea(
          child: BlocBuilder<UserCubit, UserState>(
            bloc: GetIt.I(),
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: Constants.topMargin),
                  Container(
                    padding: screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                color: AppTheme.colors.grayD4,
                                shape: BoxShape.circle),
                            child: ClipOval(
                              child: state.user?.picture ==
                                      Constants.defaultPicture
                                  ? Image.asset(
                                      state.user?.picture ?? '',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(child: Text('$error')),
                                    )
                                  : Image.file(
                                      File(state.user?.picture ?? ''),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(child: Text('$error')),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: mediaQuery.height * .03),
                        SizedBox(
                          width: 800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                  backgroundColor: Colors.transparent),
                              Text(
                                state.user?.name ?? '',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.textStyles.titleTextStyle,
                              ),
                              SizedBox(
                                height: mediaQuery.width * .03,
                              ),
                              IconButton(
                                  onPressed: () => _editName(context),
                                  icon: Icon(
                                    Icons.mode_edit_outline_rounded,
                                    color: AppTheme.colors.hintColor,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: mediaQuery.width * .05,
                    ),
                    height: 2,
                    decoration: BoxDecoration(color: AppTheme.colors.grayD4),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Versão : ${state.versionApp}',
                        style: AppTheme.textStyles.bodyTextStyle,
                      ),
                      SizedBox(height: mediaQuery.height * .03),
                    ],
                  )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _saveEdits(BuildContext context) async {
    var result = await GetIt.I<UserCubit>().saveEdits();
    var state = GetIt.I<UserCubit>().state;

    if (result == 1) {
      await showFlushbar(context, state.successMessage, false);
      return Navigator.pop(context);
    } else {
      await showFlushbar(context, state.errorMessage, true);
    }
  }

  void _editName(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            height: mediaQuery.height * .3,
            width: mediaQuery.width,
            padding: EdgeInsets.symmetric(
              vertical: mediaQuery.height * .02,
              horizontal: mediaQuery.height * .04,
            ),
            color: AppTheme.colors.appBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    height: 10,
                    width: 40,
                    decoration: BoxDecoration(
                        color: AppTheme.colors.hintColor,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                CustomTextField(
                  hint: '',
                  controller: nameController,
                  icon: Icons.text_fields_sharp,
                ),
                SizedBox(height: mediaQuery.height * .03),
              ],
            ),
          ),
        ),
      ),
    ).then(
      (value) {
        if (nameController.text.isEmpty) {
          return;
        } else {
          GetIt.I<UserCubit>().editName(nameController.text);
        }
      },
    );
  }

  // void _editSalary(BuildContext context) {
  //   var mediaQuery = MediaQuery.of(context).size;
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) => Padding(
  //       padding: MediaQuery.of(context).viewInsets,
  //       child: SingleChildScrollView(
  //         child: Container(
  //           height: mediaQuery.height * .3,
  //           width: mediaQuery.width,
  //           padding: EdgeInsets.symmetric(
  //             vertical: mediaQuery.height * .02,
  //             horizontal: mediaQuery.height * .04,
  //           ),
  //           color: Colors.transparent,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Center(
  //                 child: Container(
  //                   margin: const EdgeInsets.only(bottom: 30),
  //                   height: 10,
  //                   width: 40,
  //                   decoration: BoxDecoration(
  //                       color: Colors.black,
  //                       borderRadius: BorderRadius.circular(20)),
  //                 ),
  //               ),
  //               CustomTextField(
  //                 hint: '',
  //                 controller: priceController,
  //                 icon: Icons.attach_money_rounded,
  //                 keyboardType: TextInputType.number,
  //               ),
  //               SizedBox(height: mediaQuery.height * .03),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   ).then(
  //     (value) {
  //       if (priceController.text.isEmpty) {
  //         return;
  //       } else {
  //         final String price = priceController.text.replaceAll(',', '.');
  //         GetIt.I<UserCubit>().editSalary(double.parse(price));
  //       }
  //     },
  //   );
  // }
}
