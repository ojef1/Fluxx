import 'package:Fluxx/blocs/bill_bloc/bill_cubit.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_bloc.dart';
import 'package:Fluxx/blocs/revenue_bloc/revenue_state.dart';
import 'package:Fluxx/components/custom_text_field.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddRevenuePage extends StatefulWidget {
  const AddRevenuePage({
    super.key,
  });

  @override
  State<AddRevenuePage> createState() => _AddRevenuePageState();
}

class _AddRevenuePageState extends State<AddRevenuePage> {
  late TextEditingController nameController;
  late TextEditingController valueController;
  late final RevenueModel? revenueModel;
  bool isPublic = false;
  bool isEditing = false;

  @override
  void initState() {
    nameController = TextEditingController();
    valueController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    revenueModel = ModalRoute.of(context)!.settings.arguments as RevenueModel?;
    _hasData(revenueModel);
  }

  @override
  void dispose() {
    nameController.dispose();
    valueController.dispose();
    GetIt.I<BillCubit>().resetState();
    super.dispose();
  }

  void _hasData(RevenueModel? revenueModel) {
    if (revenueModel!.name != null) {
      bool _isPublic = revenueModel.isPublic == 1;
      setState(() {
        nameController.text = revenueModel.name ?? '';
        valueController.text = (revenueModel.value ?? 0).toString();
        isPublic = _isPublic;
        isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //AppBar
                Container(
                  margin: const EdgeInsets.only(top: Constants.topMargin),
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
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, AppRoutes.home),
                            icon: const Icon(Icons.arrow_back_rounded)),
                      ),
                      Text(
                        isEditing ? 'Editar Renda' : 'Adicionar Renda',
                        style: AppTheme.textStyles.titleTextStyle,
                      ),
                      CircleAvatar(
                        backgroundColor: AppTheme.colors.grayD4,
                        child: IconButton(
                            color: Colors.black,
                            onPressed: () => _showInfoDialog(context),
                            icon: const Icon(Icons.question_mark_rounded)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewInsets.top),
                  child: Container(
                    width: mediaQuery.width,
                    height: mediaQuery.height * .8,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CustomTextField(
                              hint: 'Nome da Renda',
                              controller: nameController,
                              icon: Icons.text_fields_sharp,
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            CustomTextField(
                              hint: 'Valor total da Renda',
                              controller: valueController,
                              icon: Icons.attach_money_rounded,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: mediaQuery.height * .03),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: mediaQuery.height * .05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Renda válida para todos os meses?',
                                    style: AppTheme.textStyles.accentTextStyle,
                                  ),
                                  Switch(
                                    value: isPublic,
                                    activeColor: AppTheme.colors.accentColor,
                                    activeTrackColor: Colors.white,
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor:
                                        AppTheme.colors.accentColor,
                                    onChanged: (value) {
                                      setState(() {
                                        isPublic = value;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            if (isEditing)
                              Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(3),
                                width: mediaQuery.width * .85,
                                child: ElevatedButton(
                                  onPressed: () => _showDeleteDialog(
                                      context, revenueModel!.id!),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    minimumSize: const Size(50, 50),
                                  ),
                                  child: Text('Excluir',
                                      style: AppTheme.textStyles.bodyTextStyle),
                                ),
                              ),
                            BlocBuilder<RevenueCubit, RevenueState>(
                              bloc: GetIt.I(),
                              buildWhen: (previous, current) =>
                                  previous.addRevenueResponse !=
                                  current.addRevenueResponse,
                              builder: (context, state) {
                                bool isLoading = state.addRevenueResponse ==
                                    AddRevenueResponse.loading;
                                return Container(
                                  decoration: BoxDecoration(
                                      color: AppTheme.colors.accentColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.all(3),
                                  width: mediaQuery.width * .85,
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => _verifyData(
                                            revenueModel!.monthId,
                                            revenueId: revenueModel?.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppTheme.colors.accentColor,
                                      minimumSize: const Size(50, 50),
                                    ),
                                    child: isLoading
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            isEditing ? 'Editar' : 'Adicionar',
                                            style: AppTheme
                                                .textStyles.bodyTextStyle),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).padding.top + kToolbarHeight,
              left: 20,
              right: 50,
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Tipo de renda que está sendo criada:',
                        style: AppTheme.textStyles.subTileTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      Text(
                        'O toggle permite definir o tipo de renda que está sendo criada.',
                        style: AppTheme.textStyles.accentTextStyle,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      Text(
                        'Se ativado, ela será global e se aplicará automaticamente a todos os meses, ideal para rendas fixas como salário. ',
                        style: AppTheme.textStyles.accentTextStyle,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                      Text(
                        'Se desativado, a renda será específica do mês atual, útil para ganhos pontuais como freelances.',
                        style: AppTheme.textStyles.accentTextStyle,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String revenueId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            maxLines: 4,
            textAlign: TextAlign.center,
            'Tem certeza de que deseja excluir este item?',
            style: AppTheme.textStyles.tileTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: AppTheme.textStyles.accentTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteRevenue(revenueId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Excluir',
                style: AppTheme.textStyles.bodyTextStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _verifyData(int? monthId, {String? revenueId}) async {
    if (nameController.text.isEmpty) {
      showFlushbar(context, 'preencha o campo do nome', true);
      return;
    }
    if (valueController.text.isEmpty) {
      showFlushbar(context, 'preencha o campo do valor', true);
      return;
    }
    if (nameController.text.isNotEmpty && valueController.text.isNotEmpty) {
      if (isEditing) {
        _editRevenue(monthId, revenueId!);
      } else {
        _addNewRevenue(monthId);
      }
    }
  }

  Future<void> _editRevenue(
    int? monthId,
    String revenueId,
  ) async {
    final String value = valueController.text.replaceAll(',', '.');

    var newRevenue = RevenueModel(
        id: revenueId,
        name: nameController.text,
        monthId: monthId,
        value: double.parse(value),
        isPublic: isPublic ? 1 : 0);
    var result = await GetIt.I<RevenueCubit>().editRevenue(newRevenue);
    var state = GetIt.I<RevenueCubit>().state;
    if (result != -1) {
      showFlushbar(context, state.successMessage, false);
    } else {
      showFlushbar(context, state.errorMessage, true);
    }
  }

  Future<void> _addNewRevenue(
    int? monthId,
  ) async {
    final String value = valueController.text.replaceAll(',', '.');

    var newRevenue = RevenueModel(
        id: codeGenerate(),
        name: nameController.text,
        monthId: monthId,
        value: double.parse(value),
        isPublic: isPublic ? 1 : 0);
    var result = await GetIt.I<RevenueCubit>().addNewRevenue(newRevenue);
    var state = GetIt.I<RevenueCubit>().state;
    if (result != -1) {
      showFlushbar(context, state.successMessage, false);
      _clearInputs();
    } else {
      showFlushbar(context, state.errorMessage, true);
    }
  }

  Future<void> _deleteRevenue(String revenueId) async {
    var result = await GetIt.I<RevenueCubit>().removeRevenue(revenueId);
    var state = GetIt.I<RevenueCubit>().state;
    if (result > 0) {
      await showFlushbar(context, state.successMessage, false);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      showFlushbar(context, state.errorMessage, true);
    }
  }

  void _clearInputs() {
    setState(() {
      nameController.clear();
      valueController.clear();
    });
  }
}
