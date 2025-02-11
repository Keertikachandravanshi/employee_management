import 'package:employee_management/bloc/employee_cubit.dart';
import 'package:employee_management/constants/app_color.dart';
import 'package:employee_management/constants/app_image.dart';
import 'package:employee_management/constants/app_string.dart';
import 'package:employee_management/view/employee_detail/employee_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class EmployeeListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> employeesList;
  const EmployeeListWidget({required this.employeesList, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: employeesList.length,
        itemBuilder: (context, index) {
          final employee = employeesList[index];
          return Dismissible(
            key: Key(employee['id'].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: AppColor.redColor,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SvgPicture.asset(AppImage.delete),
            ),
            onDismissed: (direction) async {
              context.read<EmployeeCubit>().deleteEmployee(employee['id']);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppString.employeeDataDeleted)));
            },
            child: Column(
              children: [
                ListTile(
                  title: Text(employee['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee['position']),
                      SizedBox(height: 2.sp),
                      Row(
                        children: [
                          if (employee['startDate'] != null)
                            Row(
                              children: [
                                if (employee['endDate'] == null)
                                  Text(AppString.from),
                                Text(employee['startDate']),
                              ],
                            ),
                          if (employee['endDate'] != null) Text(" - "),
                          if (employee['endDate'] != null)
                            Text(employee['endDate']),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeDetails(employee: employee),
                    ),
                  ),
                ),
                if (index != employeesList.length - 1)
                  Divider(color: AppColor.greyColor),
              ],
            ),
          );
        },
      ),
    );
  }
}
