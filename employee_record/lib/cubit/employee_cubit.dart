import 'package:employee_record/screens/employee_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../database_helper.dart';

class EmployeeCubit extends Cubit<List<Employee>> {
  EmployeeCubit() : super([]);

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Load tasks from the database
  Future<List<Employee>> loadEmployeesList() async {
    final employees = await _databaseHelper.readAllEmployees();
    print(employees);
    final List<Employee> previousEmployees = employees
        .map((element) => Employee(
            id: element["id"],
            name: element["name"],
            role: element["role"],
            startDate: element["startDate"],
            endDate: element["endDate"]))
        .toList();
    print(previousEmployees);
    emit(previousEmployees);
    return previousEmployees;
  }

  
  Future<void> addEmployee(
      String name, String role, String startDate, String endDate) async {
    await _databaseHelper.createEmployee({
      'name': name,
      'role': role,
      'startDate': startDate,
      'endDate': endDate
    });
    await loadEmployeesList();
  }

  
  Future<void> updateEmployee(int id, String name, String role,
      String startDate, String? endDate) async {
    await _databaseHelper.updateEmployee({
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate,
      'endDate': endDate
    });
    await loadEmployeesList();
  }

  
  Future<void> deleteEmployee(int id) async {
    await _databaseHelper.deleteEmployee(id);
    await loadEmployeesList();
  }
}
