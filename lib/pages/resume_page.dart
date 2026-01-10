import 'dart:io';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/user_cubit/user_cubit.dart';
import 'package:Fluxx/blocs/user_cubit/user_state.dart';
import 'package:Fluxx/components/Invoice_due_soon_widget.dart';
import 'package:Fluxx/components/available_revenues.dart';
import 'package:Fluxx/components/month_resume_data.dart';
import 'package:Fluxx/components/quick_access_widget.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/services/app_period_service.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  late final ScrollController _pageScrollController;
  late final String greeting;
  late MonthModel currentMonth;

  @override
  void initState() {
    greeting = GetIt.I<ResumeCubit>().getGreeting();
    GetIt.I<UserCubit>().getUserInfos();
    _pageScrollController = ScrollController();
    init();
    super.initState();
  }

  Future<void> init() async {
    currentMonth = AppPeriodService().currentMonth;

    AppPeriodService().updateMonthInFocus(currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: AppTheme.colors.appBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _pageScrollController,
            child: Column(
              spacing: 20,
              children: [
                //AppBar
                Container(
                  margin: const EdgeInsets.only(top: Constants.topMargin),
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width * .05,
                  ),
                  child: BlocBuilder<UserCubit, UserState>(
                    bloc: GetIt.I(),
                    builder: (context, state) => GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.profilePage,
                      ).then(
                        (value) => init(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: AppTheme.colors.grayD4,
                                shape: BoxShape.circle),
                            child: ClipOval(
                              child: state.user?.picture ==
                                      Constants.defaultPicture
                                  ? Image.asset(
                                      Constants.defaultPicture,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        Constants.defaultPicture,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.file(
                                      File(state.user?.picture ?? ''),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        Constants.defaultPicture,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width: mediaQuery.width * .07),
                          Expanded(
                            child: Text(
                              '$greeting ${state.user?.name ?? 'Usuário'}',
                              style: AppTheme.textStyles.titleTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //Resumo
                const MonthResumeData(),
                //Acesso Rápido
                const SizedBox(
                  height: 80,
                  child: QuickAccessWidget(),
                ),
                //Fatura mais próxima de fechar
                const InvoiceDueSoonWidget(),
                //Receitas Disponíveis
                const AvailableRevenues()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
