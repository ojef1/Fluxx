import 'package:Fluxx/blocs/bills_cubit/bill_list_cubit.dart';
import 'package:Fluxx/components/bill_item.dart';
import 'package:Fluxx/components/custom_loading.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_bill_list.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CommonsBillsPage extends StatefulWidget {
  const CommonsBillsPage({super.key});

  @override
  State<CommonsBillsPage> createState() => _CommonsBillsPageState();
}

class _CommonsBillsPageState extends State<CommonsBillsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<BillListCubit, ListBillState>(
        bloc: GetIt.I(),
        builder: (context, state) {
          switch (state.status) {
            case ResponseStatus.initial:
            case ResponseStatus.loading:
              return const CustomLoading();
            case ResponseStatus.error:
              return Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Center(
                  child: Text(
                    'Erro ao carregar as contas.',
                    style: AppTheme.textStyles.secondaryTextStyle,
                  ),
                ),
              );
            case ResponseStatus.success:
              return const _CommonsBillsPageContent();
          }
        },
      ),
    );
  }
}

class _CommonsBillsPageContent extends StatefulWidget {
  const _CommonsBillsPageContent();

  @override
  State<_CommonsBillsPageContent> createState() =>
      __CommonsBillsPageContentState();
}

class __CommonsBillsPageContentState extends State<_CommonsBillsPageContent> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocBuilder<BillListCubit, ListBillState>(
        bloc: GetIt.I(),
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Constants.topMargin),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => goToBillForm(context: context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors.itemBackgroundColor,
                        minimumSize: const Size(50, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(6))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          color: AppTheme.colors.hintColor,
                        ),
                        const SizedBox(width: 10),
                        Text('Adicionar',
                            style: AppTheme.textStyles.bodyTextStyle),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.billStatsPage),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colors.itemBackgroundColor,
                        minimumSize: const Size(50, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(6))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.bar_chart_rounded,
                          color: AppTheme.colors.hintColor,
                        ),
                        const SizedBox(width: 10),
                        Text('Estatísticas',
                            style: AppTheme.textStyles.bodyTextStyle),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              state.bills.isEmpty
                  ? EmptyBillList(onPressed: () {})
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.bills.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            BillItem(bill: state.bills[index]),
                            if (index == state.bills.length)
                              SizedBox(height: mediaQuery.height * .5),
                          ],
                        );
                      },
                    )
            ],
          );
        });
  }
}
