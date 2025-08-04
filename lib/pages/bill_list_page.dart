import 'package:Fluxx/blocs/bill_list_cubit/bill_list_cubit.dart';
import 'package:Fluxx/blocs/bill_list_cubit/bill_list_state.dart';
import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/bill_item.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_bill_list.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class BillListPage extends StatefulWidget {
  const BillListPage({super.key});

  @override
  State<BillListPage> createState() => _BillListPageState();
}

class _BillListPageState extends State<BillListPage> {
  late final MonthModel? monthInFocus;
  @override
  void initState() {
    monthInFocus = GetIt.I<ResumeCubit>().state.monthInFocus;
    GetIt.I<ListBillCubit>().getAllBills(
      monthInFocus!.id!,
    );
    super.initState();
  }

  @override
  void dispose() {
    GetIt.I<ListBillCubit>().resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.colors.appBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(title: monthInFocus!.name ?? ''),
        body: SafeArea(
          child: BlocBuilder<ListBillCubit, ListBillState>(
            bloc: GetIt.I(),
            builder: (context, state) {
              if (state.getBillsResponse == GetBillsResponse.loaging) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.getBillsResponse == GetBillsResponse.error) {
                return const Center(child: Text('Erro ao carregar as contas.'));
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Constants.topMargin),
                    //TODO criar lógica de filtros e de pesquisa

                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: mediaQuery.width * .05,
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       const SearchBarWidget(),
                    //       CircleAvatar(
                    //         backgroundColor: AppTheme.colors.hintColor,
                    //         child: IconButton(
                    //           color: Colors.white,
                    //           onPressed: () {},
                    //           => _showBottomSheet(
                    //             context,
                    //             state.monthInFocus!.id ?? 0,1
                    //              state.categoryInFocus.toInt(),
                    //           ),
                    //           icon: const Icon(Icons.filter_alt_off_rounded),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.addBillPage,
                            arguments: BillModel(
                              monthId: monthInFocus!.id,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.colors.hintColor,
                            minimumSize: const Size(50, 50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                              ),
                              Text('Adicionar',
                                  style: AppTheme.textStyles.bodyTextStyle),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.statsPage),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.colors.hintColor,
                            minimumSize: const Size(50, 50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.bar_chart_rounded,
                                color: Colors.white,
                              ),
                              Text('Estatísticas',
                                  style: AppTheme.textStyles.bodyTextStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: mediaQuery.width * .04,
                      ),
                      height: 1,
                      color: Colors.white,
                    ),
                    state.bills.isEmpty
                        ? EmptyBillList(onPressed: (){})
                        : Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
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
                            ),
                          )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // void _showBottomSheet(BuildContext context, int monthId, int categoryId) {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) => const FilterBottomsheet());
  // }
}
