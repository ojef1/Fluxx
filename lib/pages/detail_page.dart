import 'package:Fluxx/blocs/month_detail_bloc/month_detail_cubit.dart';
import 'package:Fluxx/blocs/month_detail_bloc/month_detail_state.dart';
import 'package:Fluxx/components/bill_item.dart';
import 'package:Fluxx/components/custom_app_bar.dart';
import 'package:Fluxx/components/custom_dropdown.dart';
import 'package:Fluxx/components/month_statistic.dart';
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

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    final state = GetIt.I<MonthsDetailCubit>().state;
    // GetIt.I<MonthsDetailCubit>().getAllBills(state.monthInFocus?.id ?? 0);
    GetIt.I<MonthsDetailCubit>().getBillsByCategory(
        state.monthInFocus?.id ?? 0, state.categoryInFocus.index);
    GetIt.I<MonthsDetailCubit>()
        .getMonthTotalSpent(state.monthInFocus?.id ?? 0);
    GetIt.I<MonthsDetailCubit>()
        .getMonthTotalPayed(state.monthInFocus?.id ?? 0);
    super.initState();
  }

  @override
  void dispose() {
    GetIt.I<MonthsDetailCubit>().resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(gradient: AppTheme.colors.backgroundColor),
          height: mediaQuery.height,
          child: BlocBuilder<MonthsDetailCubit, MonthsDetailState>(
            bloc: GetIt.I(),
            builder: (context, state) {
              if (state.getBillsResponse == GetBillsResponse.loaging) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.getBillsResponse == GetBillsResponse.error) {
                return Column(
                  children: [
                    CustomAppBar(
                      title: state.monthInFocus?.name ?? '',
                      firstIcon: Icons.arrow_back_rounded,
                      firstIconSize: 25,
                      functionIcon: Icons.warning_rounded,
                      firstFunction: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                      secondFunction: () {},
                    ),
                    const Expanded(
                        child:
                            Center(child: Text('Erro ao carregar as contas.'))),
                  ],
                );
              } else {
                var dropDownInitialValue = CategoryExtension.fromIntToString(
                    state.categoryInFocus.index);
                return Container(
                  margin: EdgeInsets.only(
                    top: mediaQuery.height * .06,
                    bottom: mediaQuery.height * .02,
                    left: mediaQuery.width * .04,
                    right: mediaQuery.width * .04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(
                        title: state.monthInFocus?.name ?? '',
                        firstIcon: Icons.arrow_back_rounded,
                        firstIconSize: 25,
                        functionIcon: Icons.add,
                        firstFunction: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                        secondFunction: () => Navigator.pushNamed(
                          context,
                          AppRoutes.addBillPage,
                          arguments: BillModel(
                            monthId: state.monthInFocus?.id,
                            categoryId: state.categoryInFocus.toInt(),
                          ),
                        ),
                      ),
                      MonthStatistic(
                        title: 'Total gasto:',
                        statistic: 'R\$ ${formatPrice(state.monthTotalSpent)}',
                      ),
                      MonthStatistic(
                        title: 'Total pago:',
                        statistic: 'R\$ ${formatPrice(state.monthTotalPaid)}',
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: mediaQuery.width * .04,
                        ),
                        height: 1,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdown(
                              initialValue: dropDownInitialValue,
                              hint: 'Categorias',
                              minWidth: mediaQuery.width * .7,
                              filters: Constants.categories,
                              offset: const Offset(0, 0),
                              function: (value) async {
                                GetIt.I<MonthsDetailCubit>()
                                    .updateCategoryInFocus(value);
                                await GetIt.I<MonthsDetailCubit>()
                                    .getBillsByCategory(
                                        state.monthInFocus?.id ?? 0,
                                        CategoryExtension.fromNameToInt(value));
                              }),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.statsPage),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppTheme.colors.primaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: CircleAvatar(
                                radius: mediaQuery.width * .06,
                                backgroundColor: Colors.transparent,
                                child: const Icon(
                                  Icons.insights_rounded,
                                  color: Colors.white,
                                ),
                              ),
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
                          ? const Expanded(
                              child: Center(
                                child: Icon(
                                  Icons.more_horiz_rounded,
                                  size: 50,
                                  color: Colors.white,
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
                                        SizedBox(
                                            height: mediaQuery.height * .5),
                                    ],
                                  );
                                },
                              ),
                            )
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
//   void _showBottomSheet(BuildContext context, int monthId, int categoryId) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => AddNewBill(
//         monthId: monthId,
//         categoryId: categoryId,
//       ),
//     );
//   }
}
