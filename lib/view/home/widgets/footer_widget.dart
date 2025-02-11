import 'package:employee_management/constants/app_color.dart';
import 'package:employee_management/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(16.sp, 12.sp, 16.sp, 32.sp),
            color: AppColor.greyColor,
            child: Text(
             AppString.swipeLeftToDelete,
              style: TextStyle(
                  color: AppColor.hintColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
