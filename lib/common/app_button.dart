import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;
  final VoidCallback? onPressed;

  const AppButton(
      {required this.title,
      required this.bgColor,
      required this.textColor,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 73.w,
      height: 40.h,
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.all(Radius.circular(6.r))),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
              color: textColor, fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
