// import 'package:Fluxx/blocs/bill_list_cubit/bill_list_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_state.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_category_list.dart';
// import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
// import 'package:Fluxx/blocs/revenue_cubit/revenue_cubit.dart';
import 'package:Fluxx/components/shimmers/categorys_shimmer.dart';
import 'package:Fluxx/components/stats_item.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
// import 'package:Fluxx/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class StatsCategory extends StatelessWidget {
  const StatsCategory({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return BlocBuilder<CategoryCubit, CategoryState>(
      bloc: GetIt.I(),
      buildWhen: (previous, current) =>
          previous.getTotalByCategoryResponse !=
              current.getTotalByCategoryResponse ||
          previous.totalByCategory != current.totalByCategory,
      builder: (context, state) {
        if (state.getTotalByCategoryResponse == GetTotalResponse.loading) {
          return const CategoryShimmer();
        } else if (state.getTotalByCategoryResponse == GetTotalResponse.error) {
          return Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Erro ao carregar as receitas!',
                    style: AppTheme.textStyles.subTileTextStyle,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colors.hintColor,
                      minimumSize: const Size(50, 50),
                    ),
                    child: Text('Tentar novamente',
                        style: AppTheme.textStyles.bodyTextStyle),
                  ),
                ],
              ),
            ),
          );
        } else if (state.getTotalByCategoryResponse ==
            GetTotalResponse.success) {
          if (state.totalByCategory.isEmpty) {
            return EmptyCategoryList(
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.detailPage,
              ),
              title: 'Parece que nenhuma categoria foi atrelada as suas contas',
              subTitle: 'Clique aqui para ver suas contas',
            );
            // Padding(
            //   padding: const EdgeInsets.all(28.0),
            //   child: Center(
            //     child: Column(
            //       children: [
            //         Text(
            //           maxLines: 3,
            //           textAlign: TextAlign.center,
            //           'Opss!\n suas contas não estão atreladas a nenhuma categoria ',
            //           style: AppTheme.textStyles.subTileTextStyle,
            //         ),
            //         const SizedBox(height: 10),
            //         // ElevatedButton(
            //         //   onPressed: () => Navigator.pushNamed(
            //         //       context, AppRoutes.addCategoryPage).then((value) => _reloadPage(),),
            //         //   style: ElevatedButton.styleFrom(
            //         //     backgroundColor: AppTheme.colors.hintColor,
            //         //     minimumSize: const Size(50, 50),
            //         //   ),
            //         //   child: Text('Adicionar Nova Categoria',
            //         //       style: AppTheme.textStyles.bodyTextStyle),
            //         // ),
            //       ],
            //     ),
            //   ),
            // );
          } else {
            return SizedBox(
              height: 120,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.totalByCategory.length,

                      itemBuilder: (context, index) {
                        return StatsCategoryItem(
                          statsItem: state.totalByCategory[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  // void _reloadPage()async{
  //   final state = GetIt.I<ListBillCubit>().state;
  //   var totalRevenues = await GetIt.I<RevenueCubit>().calculateTotalRevenues();

  //   await GetIt.I<ResumeCubit>().getTotalSpent(state.monthInFocus!.id!);
  //   await GetIt.I<ResumeCubit>().calculatePercent(totalRevenues);
  //   await GetIt.I<RevenueCubit>()
  //       .calculateAvailableValue(state.monthInFocus!.id!);
  //   await GetIt.I<RevenueCubit>()
  //       .calculateRemainigRevenues(state.monthInFocus!.id!);
  //   await GetIt.I<ListBillCubit>().getAllBills(state.monthInFocus!.id!);
  //   await GetIt.I<CategoryCubit>().getTotalByCategory(state.monthInFocus!.id!);
  // }
}
