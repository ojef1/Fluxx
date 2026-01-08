import 'package:Fluxx/blocs/resume_cubit/resume_cubit.dart';
import 'package:Fluxx/blocs/user_cubit/user_cubit.dart';
import 'package:Fluxx/components/custom_loading.dart';
import 'package:Fluxx/components/primary_button.dart';
import 'package:Fluxx/models/month_model.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late final String greeting;
  late MonthModel actualMonth;
  bool error = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    setState(() {
      error = false;
    });
    try {
      await Future.wait([
        _loadGreeting(),
        _loadUserInfos(),
        _loadActualMonth(),
      ]);
      _onInitComplete();
    } catch (e) {
      setState(() {
      error = true;
    });
      debugPrint('Error during intro initialization: $e');
    }
  }

  

  Future<void> _loadGreeting() async {
    greeting = GetIt.I<ResumeCubit>().getGreeting();
  }

  Future<void> _loadUserInfos() async {
    GetIt.I<UserCubit>().getUserInfos();
  }

  Future<void> _loadActualMonth() async {
    actualMonth = await GetIt.I<ResumeCubit>().getActualMonth();
    GetIt.I<ResumeCubit>().updateMonthInFocus(actualMonth);
  }

  void _onInitComplete() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.homePage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.appBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/app/splash.png', width: 150, height: 150),
            if (error)
            Text(
              'Ocorreu um erro ao carregar seus dados.',
              style: AppTheme.textStyles.secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
            if (error)
            PrimaryButton(
              text: "tentar novamente",
              onPressed: () => init(),
              width: 150,
              color: AppTheme.colors.itemBackgroundColor,
              textStyle: AppTheme.textStyles.secondaryTextStyle
                  .copyWith(color: AppTheme.colors.white),
            ),
            if (!error)
              const CustomLoading(padding: EdgeInsets.zero),
            const SizedBox(height: 20),
            if (!error)
              Text(
                'Carregando seus dados',
                style: AppTheme.textStyles.secondaryTextStyle,
              ),
          ],
        ),
      ),
    );
  }
}
