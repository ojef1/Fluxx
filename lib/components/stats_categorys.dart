import 'package:Fluxx/blocs/category_cubit/category_cubit.dart';
import 'package:Fluxx/blocs/category_cubit/category_state.dart';
import 'package:Fluxx/components/empty_list_placeholder/empty_category_list.dart';
import 'package:Fluxx/components/stats_item.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class StatsCategory extends StatelessWidget {
  const StatsCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      bloc: GetIt.I(),
      buildWhen: (previous, current) =>
          previous.getTotalByCategoryResponse !=
              current.getTotalByCategoryResponse ||
          previous.totalByCategory != current.totalByCategory,
      builder: (context, state) {
        if (state.getTotalByCategoryResponse == GetTotalResponse.loading) {
          return const SizedBox();
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
              onPressed: () => goToMonthBillsPage(context: context),
              title: 'Parece que nenhuma categoria foi atrelada as suas contas',
              subTitle: 'Clique aqui para ver suas contas',
            );
          } else {
            return SizedBox(
              height: 120,
              child: state.totalByCategory.length > 1
                  ? Row(
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
                    )
                  : Center(
                    child: StatsCategoryItem(
                      statsItem: state.totalByCategory.first,
                    ),
                  ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
