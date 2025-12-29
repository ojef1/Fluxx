import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/blocs/revenue_cubit/revenue_state.dart';
import 'package:Fluxx/blocs/revenue_form_cubit/revenue_form_cubit.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_revenue_list.dart';
import 'package:Fluxx/models/revenue_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/helpers.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RevenueListPage extends StatefulWidget {
  const RevenueListPage({
    super.key,
  });

  @override
  State<RevenueListPage> createState() => _RevenueListPageState();
}

class _RevenueListPageState extends State<RevenueListPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    var actualMonth = await GetIt.I<ResumeCubit>().getActualMonth();
    GetIt.I<RevenueCubit>().getRevenues(actualMonth.id!);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocListener<RevenueFormCubit, RevenueFormState>(
      listenWhen: (previous, current) =>
          previous.responseStatus != current.responseStatus,
      bloc: GetIt.I(),
      listener: (context, state) {
        if (state.responseStatus == ResponseStatus.success) {
          init();
        }
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppTheme.colors.appBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: const CustomAppBar(title: 'Lista de Rendas'),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.width * .05,
              ),
              child: Column(
                children: [
                  const SizedBox(height: Constants.topMargin),
                  BlocBuilder<RevenueCubit, RevenueState>(
                    bloc: GetIt.I(),
                    buildWhen: (previous, current) =>
                        previous.revenuesList != current.revenuesList,
                    builder: (context, state) {
                      if (state.revenuesList.isEmpty) {
                        var currentMonthId =
                            GetIt.I<ResumeCubit>().state.currentMonth!.id;

                        return EmptyRevenueList(
                          onPressed: () {
                            RevenueModel revenue = RevenueModel();
                            Navigator.pushNamed(
                                    context, AppRoutes.revenueFormPage,
                                    arguments: revenue)
                                .then(
                              (value) {
                                GetIt.I<RevenueCubit>()
                                    .calculateAvailableValue(currentMonthId!);
                              },
                            );
                          },
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.revenuesList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.itemBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  title: Text(state.revenuesList[index].name!,
                                      style: AppTheme.textStyles.bodyTextStyle),
                                  trailing: Text(
                                    'R\$ ${formatPrice(state.revenuesList[index].value ?? 0)}',
                                    style: AppTheme.textStyles.bodyTextStyle,
                                  ),
                                  onTap: () => goToRevenueForm(
                                    context: context,
                                    revenue: state.revenuesList[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
