import 'package:employee_management/constants/app_color.dart';
import 'package:employee_management/constants/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? showAction;
  final VoidCallback? onTapDelete;
  const AppbarWidget(
      {required this.title, this.showAction, this.onTapDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primaryColor,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyle(
          color: AppColor.whiteColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        if (showAction == true)
          InkWell(
            onTap: onTapDelete,
            child: Padding(
              padding: EdgeInsets.all(8.sp),
              child: SvgPicture.asset(AppImage.delete),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
