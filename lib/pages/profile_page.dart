import 'dart:io';

import 'package:Fluxx/blocs/user_bloc/user_cubit.dart';
import 'package:Fluxx/blocs/user_bloc/user_state.dart';
import 'package:Fluxx/components/custom_app_bar.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/components/profile_item.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    var state = GetIt.I<UserCubit>().state;
    nameController.text = state.user?.name ?? '';
    priceController.text = state.user?.salary.toString() ?? '';
    super.initState();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      GetIt.I<UserCubit>().editPicture(pickedFile.path);
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
        body: SafeArea(
          child: BlocBuilder<UserCubit, UserState>(
              bloc: GetIt.I(),
              builder: (context, state) {
                // if (state.getUserResponse == GetUserResponse.loaging) {
                //   return const Center(child: CircularProgressIndicator());
                // } else if (state.getUserResponse == GetUserResponse.error) {
                //   return Column(
                //     children: [
                //       CustomAppBar(
                //         title: 'Estatísticas',
                //         firstIcon: Icons.arrow_back_rounded,
                //         firstIconSize: 25,
                //         functionIcon: Icons.warning_rounded,
                //         firstFunction: () => Navigator.pushReplacementNamed(
                //             context, AppRoutes.home),
                //         secondFunction: () {},
                //       ),
                //       const Expanded(
                //           child: Center(
                //               child: Text('Erro ao carregar suas informações.'))),
                //     ],
                //   );
                // } else {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: Constants.topMargin),
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * .05,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.colors.grayD4,
                            child: IconButton(
                                color: Colors.black,
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back_rounded)),
                          ),
                          Text(
                            'Perfil',
                            style: AppTheme.textStyles.titleTextStyle,
                          ),
                          const CircleAvatar(
                              backgroundColor: Colors.transparent),
                        ],
                      ),
                    ),
                    Container(
                      padding: screenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap:  _pickImage,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: AppTheme.colors.accentColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: state.user?.picture ==
                                        Constants.defaultPicture
                                    ? Image.asset(
                                        state.user?.picture ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(),
                                      )
                                    : Image.file(
                                        File(state.user?.picture ?? ''),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(),
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
                                  state.user?.name ?? 'Mayara',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.textStyles.titleTextStyle,
                                ),
                                SizedBox(
                                  height: mediaQuery.width * .03,
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                        Icons.mode_edit_outline_rounded))
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
                      decoration:
                          BoxDecoration(color: AppTheme.colors.accentColor),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Versão : {versão}',
                          style: AppTheme.textStyles.accentTextStyle,
                        ),
                        SizedBox(height: mediaQuery.height * .03),
                      ],
                    ))
                    // ProfileItem(
                    //   icon: Icons.cameraswitch_rounded,
                    //   label: 'Editar Foto',
                    //   function: _pickImage,
                    // ),
                    // ProfileItem(
                    //   icon: Icons.edit,
                    //   label: 'Editar Nome',
                    //   function: () => _editName(context),
                    // ),
                    // ProfileItem(
                    //   icon: Icons.attach_money_rounded,
                    //   label: 'Editar Salário',
                    //   function: () => _editSalary(context),
                    // ),
                  ],
                );
              }
              // },
              ),
        ),
      ),
    );
  }

  Future<void> _saveEdits(BuildContext context) async {
    await GetIt.I<UserCubit>().saveEdits().then(
      (value) {
        if (value == 1) {
          return Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
    );
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
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    height: 10,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.black,
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

  void _editSalary(BuildContext context) {
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
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    height: 10,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                CustomTextField(
                  hint: '',
                  controller: priceController,
                  icon: Icons.attach_money_rounded,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: mediaQuery.height * .03),
              ],
            ),
          ),
        ),
      ),
    ).then(
      (value) {
        if (priceController.text.isEmpty) {
          return;
        } else {
          final String price = priceController.text.replaceAll(',', '.');
          GetIt.I<UserCubit>().editSalary(double.parse(price));
        }
      },
    );
  }
}
