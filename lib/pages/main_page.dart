import 'package:Fluxx/blocs/months_list_bloc/months__list_cubit.dart';
import 'package:Fluxx/blocs/months_list_bloc/months_list_state.dart';
import 'package:Fluxx/blocs/user_bloc/user_cubit.dart';
import 'package:Fluxx/blocs/user_bloc/user_state.dart';
import 'package:Fluxx/components/custom_app_bar.dart';
import 'package:Fluxx/components/month.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    GetIt.I<MonthsListCubit>().getMonths();
    GetIt.I<UserCubit>().getUserInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.colors.backgroundColor),
        height: mediaQuery.height,
        child: Column(
          children: [
            BlocBuilder<UserCubit, UserState>(
              bloc: GetIt.I(),
              builder: (context, state) => Container(
                margin: EdgeInsets.only(
                  top: mediaQuery.height * .06,
                  bottom: mediaQuery.height * .02,
                  left: mediaQuery.width * .04,
                  right: mediaQuery.width * .04,
                ),
                child: CustomAppBar(
                  title: 'Olá, ${state.user?.name}',
                  firstIcon: Icons.account_circle,
                  functionIcon: Icons.help,
                  firstFunction: () => Navigator.pushReplacementNamed(
                      context, AppRoutes.profilePage),
                  secondFunction: () => _showDialog(context),
                ),
              ),
            ),
            BlocBuilder<MonthsListCubit, MonthsListState>(
              bloc: GetIt.I(),
              builder: (context, state) {
                if (state.getMonthsResponse == GetMonthsResponse.loaging) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                } else if (state.getMonthsResponse == GetMonthsResponse.error) {
                  return const Expanded(
                      child: Center(child: Text('Erro ao carregar meses.')));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.months.length,
                      itemBuilder: (context, index) {
                        return Month(
                          month: state.months[index],
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
    );
  }
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>  AlertDialog(shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const  Row(
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
