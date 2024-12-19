import 'package:Fluxx/blocs/months_list_bloc/months__list_cubit.dart';
import 'package:Fluxx/blocs/months_list_bloc/months_list_state.dart';
import 'package:Fluxx/blocs/user_bloc/user_cubit.dart';
import 'package:Fluxx/components/month.dart';
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
    GetIt.I<UserCubit>().getUserInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppTheme.colors.appBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _pageScrollController,
            child: Column(
              children: [
                // BlocBuilder<UserCubit, UserState>(
                //   bloc: GetIt.I(),
                //   builder: (context, state) => Container(
                //     margin: EdgeInsets.only(
                //       top: mediaQuery.height * .06,
                //       bottom: mediaQuery.height * .02,
                //       left: mediaQuery.width * .04,
                //       right: mediaQuery.width * .04,
                //     ),
                //     child: CustomAppBar(
                //       title: 'Olá, ${state.user?.name}',
                //       firstIcon: Icons.account_circle,
                //       functionIcon: Icons.help,
                //       firstFunction: () => Navigator.pushReplacementNamed(
                //           context, AppRoutes.profilePage),
                //       secondFunction: () => _showDialog(context),
                //     ),
                //   ),
                // ),
                //AppBar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: Constants.topMargin),
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
                      SizedBox(width: mediaQuery.width * .15),
                      Text(
                        'Lista de Meses',
                        style: AppTheme.textStyles.titleTextStyle,
                      ),
                    ],
                  ),
                ),

                BlocBuilder<MonthsListCubit, MonthsListState>(
                  bloc: GetIt.I(),
                  builder: (context, state) {
                    if (state.getMonthsResponse == GetMonthsResponse.loaging) {
                      return const Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    } else if (state.getMonthsResponse ==
                        GetMonthsResponse.error) {
                      return const Expanded(
                          child:
                              Center(child: Text('Erro ao carregar meses.')));
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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Versão: Beta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.info_outline, color: Colors.purple),
          ],
        ),
      ),
    );
  }
}
