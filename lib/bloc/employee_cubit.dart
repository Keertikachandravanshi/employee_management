
import 'package:employee_management/data/db_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final DatabaseHelper dbHelper;

  EmployeeCubit(this.dbHelper)
      : super(EmployeeState(currentEmployees: [], previousEmployees: []));

  Future<void> loadEmployees() async {
    final currentEmployees = await dbHelper.fetchCurrentEmployees();
    final previousEmployees = await dbHelper.fetchPreviousEmployees();

    emit(EmployeeState(
      currentEmployees: currentEmployees,
      previousEmployees: previousEmployees,
    ));
  }

  Future<void> addEmployee(Map<String, dynamic> employee) async {
    await dbHelper.addEmployee(employee);
    await loadEmployees();
  }

  Future<void> updateEmployee(int id, Map<String, dynamic> employee) async {
    await dbHelper.updateEmployee(id, employee);
    await loadEmployees();
  }

  Future<void> deleteEmployee(int id) async {
    await dbHelper.deleteEmployee(id);
    await loadEmployees();
  }
}
