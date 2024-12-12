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
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(gradient: AppTheme.colors.backgroundColor),
          height: mediaQuery.height,
          child: BlocBuilder<UserCubit, UserState>(
            bloc: GetIt.I(),
            builder: (context, state) {
              if (state.getUserResponse == GetUserResponse.loaging) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.getUserResponse == GetUserResponse.error) {
                return Column(
                  children: [
                    CustomAppBar(
                      title: 'Estatísticas',
                      firstIcon: Icons.arrow_back_rounded,
                      firstIconSize: 25,
                      functionIcon: Icons.warning_rounded,
                      firstFunction: () => Navigator.pushReplacementNamed(
                          context, AppRoutes.home),
                      secondFunction: () {},
                    ),
                    const Expanded(
                        child: Center(
                            child: Text('Erro ao carregar suas informações.'))),
                  ],
                );
              } else {
                return Container(
                  margin: EdgeInsets.only(
                    top: mediaQuery.height * .06,
                    bottom: mediaQuery.height * .02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: screenPadding,
                        child: CustomAppBar(
                          title: 'Perfil',
                          firstIcon: Icons.arrow_back_rounded,
                          firstIconSize: 25,
                          functionIcon: Icons.check,
                          firstFunction: () => Navigator.pushReplacementNamed(
                              context, AppRoutes.home),
                          secondFunction: () => _saveEdits(context),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 100),
                        padding: screenPadding,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                gradient: AppTheme.colors.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: state.user?.picture ==
                                        Constants.defaultPicture
                                    ? Image.asset(
                                        state.user?.picture ?? '',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(state.user?.picture ?? ''),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Text(
                                    state.user?.name ?? '',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTheme.textStyles.titleTextStyle,
                                  ),
                                ),
                                Text(
                                  'R\$ ${formatPrice(state.user?.salary ?? 0)}',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.textStyles.titleTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: mediaQuery.width * .05,
                        ),
                        height: 2,
                        decoration: BoxDecoration(
                            gradient: AppTheme.colors.primaryColor),
                      ),
                      ProfileItem(
                        icon: Icons.cameraswitch_rounded,
                        label: 'Editar Foto',
                        function: _pickImage,
                      ),
                      ProfileItem(
                        icon: Icons.edit,
                        label: 'Editar Nome',
                        function: () => _editName(context),
                      ),
                      ProfileItem(
                        icon: Icons.attach_money_rounded,
                        label: 'Editar Salário',
                        function: () => _editSalary(context),
                      ),
                    ],
                  ),
                );
              }
            },
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
