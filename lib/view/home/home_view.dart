import 'package:employee_management/common/appbar_widget.dart';
import 'package:employee_management/bloc/employee_cubit.dart';
import 'package:employee_management/constants/app_color.dart';
import 'package:employee_management/constants/app_string.dart';
import 'package:employee_management/view/employee_detail/employee_details.dart';
import 'package:employee_management/view/home/widgets/do_data_widget.dart';
import 'package:employee_management/view/home/widgets/employee_list_widget.dart';
import 'package:employee_management/view/home/widgets/footer_widget.dart';
import 'package:employee_management/view/home/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppbarWidget(title: AppString.employeeList),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, employees) {
          return employees.currentEmployees.isEmpty &&
                  employees.previousEmployees.isEmpty
              ? NoDataWidget()
              : Column(
                  children: [
                    HeaderWidget(title: AppString.currentEmployees),
                    SizedBox(height: 16.sp),
                    EmployeeListWidget(
                        employeesList: employees.currentEmployees),
                    HeaderWidget(title: AppString.previousEmployees),
                    SizedBox(height: 16.sp),
                    EmployeeListWidget(
                        employeesList: employees.previousEmployees),
                    FooterWidget()
                  ],
                );
        },
      ),
      floatingActionButton: SizedBox(
        height: 50.sp,
        width: 50.sp,
        child: FloatingActionButton(
          backgroundColor: AppColor.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.add, color: AppColor.whiteColor),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmployeeDetails()),
          ),
        ),
      ),
    );
  }
}
