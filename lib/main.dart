import 'package:Fluxx/pages/add_bill_page.dart';
import 'package:Fluxx/pages/detail_page.dart';
import 'package:Fluxx/pages/edit_bill_page.dart';
import 'package:Fluxx/pages/main_page.dart';
import 'package:Fluxx/pages/profile_page.dart';
import 'package:Fluxx/pages/resume_page.dart';
import 'package:Fluxx/pages/stats_page.dart';
import 'package:Fluxx/utils/app_routes.dart';
import 'package:Fluxx/utils/setup_dependences.dart';
import 'package:flutter/material.dart';

void main() {
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
      ),
      routes: {
        AppRoutes.home: (ctx) => const ResumePage(),
        AppRoutes.detailPage: (ctx) => const DetailPage(),
        AppRoutes.statsPage: (ctx) => const StatsPage(),
        AppRoutes.addBillPage: (ctx) => const AddBillPage(),
        AppRoutes.editBillPage: (ctx) => const EditBillPage(),
        AppRoutes.profilePage: (ctx) => const ProfilePage(),
      },
    );
  }
}
