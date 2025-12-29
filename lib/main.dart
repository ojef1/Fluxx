import 'package:Fluxx/pages/bill_form_pageView/bill_form_page_view.dart';
import 'package:Fluxx/pages/bill_list_page.dart';
import 'package:Fluxx/pages/category_form_pageView/category_form_page_view.dart';
import 'package:Fluxx/pages/category_list_page.dart';
import 'package:Fluxx/pages/detail_bill_page.dart';
import 'package:Fluxx/pages/month_list_page.dart';
import 'package:Fluxx/pages/profile_page.dart';
import 'package:Fluxx/pages/resume_page.dart';
import 'package:Fluxx/pages/revenue_form_pageView/revenue_form_page_view.dart';
import 'package:Fluxx/pages/revenue_list_page.dart';
import 'package:Fluxx/pages/stats_page.dart';
import 'package:Fluxx/themes/app_theme.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/setup_dependences.dart';
import 'package:flashy_flushbar/flashy_flushbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Fluxx',
      theme: ThemeData(
        useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppTheme.colors.hintColor,
          selectionColor: AppTheme.colors.hintColor,
          selectionHandleColor: AppTheme.colors.hintColor,
        ),
      ),
      builder: FlashyFlushbarProvider.init(),

      routes: {
        AppRoutes.home: (ctx) => const ResumePage(),
        AppRoutes.monthListPage: (ctx) => const MonthListPage(),
        AppRoutes.categoryListPage: (ctx) => const CategoryListPage(),
        AppRoutes.revenueListPage: (ctx) => const RevenueListPage(),
        AppRoutes.detailPage: (ctx) => const BillListPage(),
        AppRoutes.statsPage: (ctx) => const StatsPage(),
        AppRoutes.billFormPage: (ctx) => const BillFormPageview(),
        AppRoutes.detailBillPage: (ctx) => const DetailBillPage(),
        AppRoutes.categoryFormPage: (ctx) => const CategoryFormPageview(),
        AppRoutes.revenueFormPage: (ctx) => const RevenueFormPageview(),
        AppRoutes.profilePage: (ctx) => const ProfilePage(),
      },
    );
  }
}
