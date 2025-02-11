import 'package:employee_management/constants/app_color.dart';
import 'package:employee_management/constants/app_image.dart';
import 'package:employee_management/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImage.noData),
          Text(
            AppString.noEmployeeRecords,
            style: TextStyle(
              color: AppColor.textColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
