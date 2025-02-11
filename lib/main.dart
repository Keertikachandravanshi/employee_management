import 'package:employee_management/bloc/employee_cubit.dart';
import 'package:employee_management/data/db_helper.dart';
import 'package:employee_management/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  final dbHelper = DatabaseHelper.instance;
  runApp(MyApp(dbHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper dbHelper;
  const MyApp(this.dbHelper, {super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return BlocProvider(
          create: (context) => EmployeeCubit(dbHelper)..loadEmployees(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.robotoTextTheme(),
            ),
            home: HomeView(),
          ),
        );
      },
    );
  }
}
