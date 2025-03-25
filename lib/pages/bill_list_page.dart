import 'package:Fluxx/blocs/bill_list_bloc/bill_list_cubit.dart';
import 'package:Fluxx/blocs/bill_list_bloc/bill_list_state.dart';
import 'package:Fluxx/components/bill_item.dart';
import 'package:Fluxx/components/custom_app_bar.dart';
import 'package:Fluxx/components/custom_dropdown.dart';
import 'package:Fluxx/components/filter_bottomsheet.dart';
import 'package:Fluxx/components/month_statistic.dart';
import 'package:Fluxx/components/search_bar.dart';
import 'package:Fluxx/extensions/category_extension.dart';
import 'package:Fluxx/models/bill_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:Fluxx/utils/helpers.dart';

class BillListPage extends StatefulWidget {
  const BillListPage({super.key});

  @override
  State<BillListPage> createState() => _BillListPageState();
}

class _BillListPageState extends State<BillListPage> {
  @override
  void initState() {
    final state = GetIt.I<ListBillCubit>().state;
    // GetIt.I<MonthsDetailCubit>().getAllBills(state.monthInFocus?.id ?? 0);
    GetIt.I<ListBillCubit>().getAllBills(
        state.monthInFocus?.id ?? 0,);
    // GetIt.I<MonthsDetailCubit>()
    //     .getMonthTotalSpent(state.monthInFocus?.id ?? 0);
    // GetIt.I<MonthsDetailCubit>()
    //     .getMonthTotalPayed(state.monthInFocus?.id ?? 0);
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
        body: SafeArea(
          child: BlocBuilder<ListBillCubit, ListBillState>(
            bloc: GetIt.I(),
            builder: (context, state) {
              if (state.getBillsResponse == GetBillsResponse.loaging) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.getBillsResponse == GetBillsResponse.error) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: Constants.topMargin),
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * .05,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.colors.grayD4,
                            child: IconButton(
                                color: Colors.black,
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back_rounded)),
                          ),
                          SizedBox(width: mediaQuery.width * .2),
                          Text(
                            state.monthInFocus?.name ?? '',
                            style: AppTheme.textStyles.titleTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                        child:
                            Center(child: Text('Erro ao carregar as contas.'))),
                  ],
                );
              } else {
                // var dropDownInitialValue = CategoryExtension.fromIntToString(
                //     state.categoryInFocus.index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //AppBar
                    Container(
                      margin: const EdgeInsets.only(
                          top: Constants.topMargin, bottom: 5),
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * .05,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.colors.grayD4,
                            child: IconButton(
                                color: Colors.black,
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back_rounded)),
                          ),
                          SizedBox(width: mediaQuery.width * .25),
                          Text(
                            state.monthInFocus?.name ?? '',
                            style: AppTheme.textStyles.titleTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * .05,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SearchBarWidget(),
                          CircleAvatar(
                            backgroundColor: AppTheme.colors.accentColor,
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () => _showBottomSheet(
                                context,
                                state.monthInFocus!.id ?? 0,
                                state.categoryInFocus.toInt(),
                              ),
                              icon: const Icon(Icons.filter_alt_off_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.addBillPage,
                            arguments: BillModel(
                              monthId: state.monthInFocus?.id,
                              // categoryId: state.categoryInFocus.toInt(),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.colors.accentColor,
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
                            backgroundColor: AppTheme.colors.accentColor,
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

                    // MonthStatistic(
                    //   title: 'Total gasto:',
                    //   statistic:
                    //       'R\$ ${formatPrice(state.monthTotalSpent)}',
                    // ),
                    // MonthStatistic(
                    //   title: 'Total pago:',
                    //   statistic: 'R\$ ${formatPrice(state.monthTotalPaid)}',
                    // ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(
                    //     vertical: mediaQuery.width * .04,
                    //   ),
                    //   height: 1,
                    //   color: Colors.white,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     CustomDropdown(
                    //         initialValue: dropDownInitialValue,
                    //         hint: 'Categorias',
                    //         minWidth: mediaQuery.width * .7,
                    //         filters: Constants.categories,
                    //         offset: const Offset(0, 0),
                    //         function: (value) async {
                    //           GetIt.I<MonthsDetailCubit>()
                    //               .updateCategoryInFocus(value);
                    //           await GetIt.I<MonthsDetailCubit>()
                    //               .getBillsByCategory(
                    //                   state.monthInFocus?.id ?? 0,
                    //                   CategoryExtension.fromNameToInt(
                    //                       value));
                    //         }),
                    //     GestureDetector(
                    //       onTap: () => Navigator.pushNamed(
                    //           context, AppRoutes.statsPage),
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           gradient: AppTheme.colors.primaryColor,
                    //           borderRadius: BorderRadius.circular(50),
                    //         ),
                    //         child: CircleAvatar(
                    //           radius: mediaQuery.width * .06,
                    //           backgroundColor: Colors.transparent,
                    //           child: const Icon(
                    //             Icons.insights_rounded,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: mediaQuery.width * .04,
                      ),
                      height: 1,
                      color: Colors.white,
                    ),
                    state.bills.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Icon(
                                Icons.more_horiz_rounded,
                                size: 50,
                                color: Colors.black,
                              ),
                            ),
                          )
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

  void _showBottomSheet(BuildContext context, int monthId, int categoryId) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => const FilterBottomsheet());
  }
}
