import 'package:Fluxx/blocs/months_list_bloc/months__list_cubit.dart';
import 'package:Fluxx/blocs/months_list_bloc/months_list_state.dart';
import 'package:Fluxx/components/app_bar.dart';
import 'package:Fluxx/components/month.dart';
import 'package:Fluxx/components/shimmers/months_shimmer.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MonthListPage extends StatefulWidget {
  const MonthListPage({super.key});

  @override
  State<MonthListPage> createState() => _MonthListPageState();
}

class _MonthListPageState extends State<MonthListPage> {
  late final ScrollController _pageScrollController;
  @override
  void initState() {
    _pageScrollController = ScrollController();
    GetIt.I<MonthsListCubit>().getMonths();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppTheme.colors.appBackgroundColor,
        appBar: const CustomAppBar(title: 'Lista de Meses'),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _pageScrollController,
            child: Column(
              children: [
                const SizedBox(height: Constants.topMargin),
                BlocBuilder<MonthsListCubit, MonthsListState>(
                  bloc: GetIt.I(),
                  builder: (context, state) {
                    if (state.getMonthsResponse == GetMonthsResponse.loading) {
                      return const MonthsShimmer();
                    } else if (state.getMonthsResponse ==
                        GetMonthsResponse.error) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 100),
                        child: Center(child: Text('Erro ao carregar meses.')),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.months.length,
                        itemBuilder: (context, index) {
                          return Month(
                            month: state.months[index],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
