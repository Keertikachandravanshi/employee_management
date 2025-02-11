part of 'employee_cubit.dart';

class EmployeeState {
  final List<Map<String, dynamic>> currentEmployees;
  final List<Map<String, dynamic>> previousEmployees;

  EmployeeState({
    required this.currentEmployees,
    required this.previousEmployees,
  });
}
