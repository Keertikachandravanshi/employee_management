import 'package:employee_management/common/app_button.dart';
import 'package:employee_management/common/appbar_widget.dart';
import 'package:employee_management/constants/app_color.dart';
import 'package:employee_management/constants/app_image.dart';
import 'package:employee_management/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_management/bloc/employee_cubit.dart';

class EmployeeDetails extends StatefulWidget {
  final Map<String, dynamic>? employee;
  const EmployeeDetails({super.key, this.employee});

  @override
  EmployeeDetailsState createState() => EmployeeDetailsState();
}

class EmployeeDetailsState extends State<EmployeeDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = "Select role";
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!['name'];
      _selectedRole = widget.employee!['position'];

      final dateFormat = DateFormat("d MMM yyyy");

      startDate = widget.employee!['startDate'] != null
          ? dateFormat.parse(widget.employee!['startDate'])
          : null;

      endDate = widget.employee!['endDate'] != null
          ? dateFormat.parse(widget.employee!['endDate'])
          : null;
    }
  }

  void _showRoleBottomSheet(BuildContext context) {
    List<String> roles = [
      AppString.productDesigner,
      AppString.flutterDeveloper,
      AppString.qaTester,
      AppString.productOwner
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 12.sp),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: roles.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRole = roles[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      roles[index],
                      style: TextStyle(
                          color: AppColor.textColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  if (index != roles.length - 1)
                    Divider(color: AppColor.greyColor),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _saveEmployee() {
    final dateFormat = DateFormat("d MMM yyyy");
    if (_formKey.currentState!.validate()) {
      final newEmployee = {
        'name': _nameController.text,
        'position': _selectedRole == "Select role" ? "" : _selectedRole,
        'startDate': startDate != null ? dateFormat.format(startDate!) : null,
        'endDate': endDate != null ? dateFormat.format(endDate!) : null
      };

      if (widget.employee == null) {
        context.read<EmployeeCubit>().addEmployee(newEmployee);
      } else {
        context
            .read<EmployeeCubit>()
            .updateEmployee(widget.employee!['id'], newEmployee);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppbarWidget(
        title: widget.employee != null
            ? AppString.editEmployeeDetails
            : AppString.addEmployeeDetails,
        showAction: widget.employee != null ? true : false,
        onTapDelete: widget.employee != null
            ? () {
                context
                    .read<EmployeeCubit>()
                    .deleteEmployee(widget.employee!['id']);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppString.employeeDataDeleted)));
                Navigator.pop(context);
              }
            : () {},
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 40.sp,
                child: TextField(
                  controller: _nameController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: SvgPicture.asset(AppImage.person),
                    ),
                    labelText: null,
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40.sp,
                      minHeight: 40.sp,
                    ),
                    hintText: AppString.employeeName,
                    hintStyle: TextStyle(
                      color: AppColor.hintColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderColor),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.sp),
              GestureDetector(
                onTap: () => _showRoleBottomSheet(context),
                child: Container(
                  height: 40.sp,
                  padding: EdgeInsets.all(5.sp),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.borderColor),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppImage.work),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedRole,
                          style: TextStyle(
                              color: _selectedRole == "Select role"
                                  ? AppColor.hintColor
                                  : AppColor.textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SvgPicture.asset(AppImage.arrowDown),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25.sp),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? newDate = await _showStartDatePicker(context);
                        if (newDate != null) {
                          setState(() {
                            startDate = newDate;
                          });
                        }
                      },
                      child: Container(
                        height: 40.sp,
                        padding: EdgeInsets.all(5.sp),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.borderColor),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(AppImage.event),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                startDate != null
                                    ? DateFormat('d MMM yyyy')
                                        .format(startDate!)
                                    : AppString.today,
                                style: TextStyle(
                                    color: AppColor.textColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SvgPicture.asset(AppImage.arrowRight),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? newDate = await _showEndDatePicker(context);
                        if (newDate != null) {
                          setState(() {
                            endDate = newDate;
                          });
                        }
                      },
                      child: Container(
                        height: 40.sp,
                        padding: EdgeInsets.all(5.sp),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor.borderColor),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(AppImage.event),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                endDate != null
                                    ? DateFormat('d MMM yyyy').format(endDate!)
                                    : AppString.noDate,
                                style: TextStyle(
                                    color: endDate != null
                                        ? AppColor.textColor
                                        : AppColor.hintColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    title: AppString.cancel,
                    bgColor: AppColor.bgColor,
                    textColor: AppColor.primaryColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 16.w),
                  AppButton(
                    title: AppString.save,
                    bgColor: AppColor.primaryColor,
                    textColor: AppColor.whiteColor,
                    onPressed: () {
                      if (_nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(AppString.enterEmployeeName)));
                      } else if (_selectedRole == "Select role" ||
                          _selectedRole == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppString.selectRole)));
                      } else if (startDate == null) {
                        setState(() {
                          startDate = DateTime.now();
                        });
                        _saveEmployee();
                      } else {
                        _saveEmployee();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _showStartDatePicker(BuildContext context) async {
    DateTime? tempSelectedDate = startDate;

    return await showDialog<DateTime?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(16.sp),
              child: AlertDialog(
                backgroundColor: AppColor.whiteColor,
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r)),
                contentPadding: EdgeInsets.zero,
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: _quickSelectButton(
                                      AppString.today, DateTime.now())),
                              SizedBox(width: 16.sp),
                              Expanded(
                                child: _quickSelectButton(AppString.nextMonday,
                                    _getNextWeekday(DateTime.monday)),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.sp),
                          Row(
                            children: [
                              Expanded(
                                child: _quickSelectButton(
                                  AppString.nextTuesday,
                                  _getNextWeekday(DateTime.tuesday),
                                ),
                              ),
                              SizedBox(width: 16.sp),
                              Expanded(
                                child: _quickSelectButton(
                                    AppString.afterOneWeek,
                                    DateTime.now().add(Duration(days: 7))),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColor.primaryColor,
                            onPrimary: AppColor.whiteColor,
                            onSurface: AppColor.textColor,
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: tempSelectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          onDateChanged: (date) {
                            setState(() => tempSelectedDate = date);
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppImage.event),
                              SizedBox(width: 10),
                              Text(
                                tempSelectedDate != null
                                    ? DateFormat('d MMM yyyy')
                                        .format(tempSelectedDate!)
                                    : AppString.today,
                                style: TextStyle(
                                    color: AppColor.textColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              AppButton(
                                title: AppString.cancel,
                                bgColor: AppColor.bgColor,
                                textColor: AppColor.primaryColor,
                                onPressed: () => Navigator.pop(context),
                              ),
                              SizedBox(width: 16.w),
                              AppButton(
                                title: AppString.save,
                                bgColor: AppColor.primaryColor,
                                textColor: AppColor.whiteColor,
                                onPressed: () {
                                  setState(() {});
                                  Navigator.pop(context, tempSelectedDate);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<DateTime?> _showEndDatePicker(BuildContext context) async {
    DateTime? tempSelectedDate = endDate;

    return await showDialog<DateTime?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(16.sp),
              child: AlertDialog(
                backgroundColor: AppColor.whiteColor,
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r)),
                contentPadding: EdgeInsets.zero,
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _quickSelectButton(AppString.noDate, null),
                          ),
                          SizedBox(width: 16.sp),
                          Expanded(
                              child: _quickSelectButton(
                                  AppString.today, DateTime.now())),
                        ],
                      ),
                      SizedBox(height: 10),
                      Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColor.primaryColor,
                            onPrimary: AppColor.whiteColor,
                            onSurface: AppColor.textColor,
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: tempSelectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          onDateChanged: (date) {
                            setState(() => tempSelectedDate = date);
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppImage.event),
                              SizedBox(width: 10),
                              Text(
                                tempSelectedDate != null
                                    ? DateFormat('d MMM yyyy')
                                        .format(tempSelectedDate!)
                                    : AppString.today,
                                style: TextStyle(
                                    color: AppColor.textColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              AppButton(
                                title: AppString.cancel,
                                bgColor: AppColor.bgColor,
                                textColor: AppColor.primaryColor,
                                onPressed: () => Navigator.pop(context),
                              ),
                              SizedBox(width: 16.w),
                              AppButton(
                                title: AppString.save,
                                bgColor: AppColor.primaryColor,
                                textColor: AppColor.whiteColor,
                                onPressed: () {
                                  setState(() {});
                                  Navigator.pop(context, tempSelectedDate);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _quickSelectButton(String label, DateTime? date) {
    return Container(
      height: 36.sp,
      decoration: BoxDecoration(
          color: AppColor.bgColor,
          borderRadius: BorderRadius.all(Radius.circular(6.r))),
      child: TextButton(
        onPressed: () {
          setState(() {
            startDate = date;
            endDate = date;
          });
          Navigator.pop(context);
        },
        child: Text(
          label,
          style: TextStyle(
              color: AppColor.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  DateTime _getNextWeekday(int weekday) {
    DateTime now = DateTime.now();
    int daysUntilNext = (weekday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysUntilNext == 0 ? 7 : daysUntilNext));
  }
}
