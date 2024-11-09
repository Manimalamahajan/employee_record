import 'package:employee_record/screens/add_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/employee_cubit.dart';

//Center(child: Image.asset('assets/images/Frame_19726.png'),),
class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});
  static const routeName = '/';
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.blue,
        title: const Text(
          'Employee List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<EmployeeCubit, List<Employee>>(
        builder: (context, employees) {
          final List<Employee> currentEmployees = employees
              .where((employees) => (employees.endDate == "No Date"))
              .toList();
          final List<Employee> previousEmployees = employees
              .where((employees) => (employees.endDate != "No Date"))
              .toList();
          if (currentEmployees.isNotEmpty || previousEmployees.isNotEmpty) {
            return Stack(children: [
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  ListView(
                      shrinkWrap: true,
                      //scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      children: [
                        const SectionTitle(title: 'Current employees'),
                        ...currentEmployees.map((employee) => InkWell(
                            onTap: () {
                              //context.read<EmployeeCubit>().updateEmployee(employee.id,employee.name,employee.role,employee.startDate,employee.endDate);
                              Navigator.of(context).pushReplacementNamed(
                                  AddEmployee.routeName,
                                  arguments: {
                                    'mode': 'edit',
                                    'id': employee.id,
                                    'name': employee.name,
                                    'role': employee.role,
                                    'startDate': employee.startDate,
                                    'endDate': employee.endDate
                                  });
                            },
                            child: EmployeeTile(employee: employee))),
                        const SizedBox(height: 16),
                        const SectionTitle(title: 'Previous employees'),
                        ...previousEmployees.map((employee) => InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  AddEmployee.routeName,
                                  arguments: {
                                    'mode': 'edit',
                                    'id': employee.id,
                                    'name': employee.name,
                                    'role': employee.role,
                                    'startDate': employee.startDate,
                                    'endDate': employee.endDate
                                  });
                            },
                            child: EmployeeTile(employee: employee))),
                      ]),
                ]),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    "Swipe left to delete",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              ),
            ]);
          }
          return Center(
            child: Image.asset('assets/images/Frame_19726.png'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(AddEmployee.routeName,
              arguments: {'mode': 'add'});
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class EmployeeTile extends StatelessWidget {
  final Employee employee;

  const EmployeeTile({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        context.read<EmployeeCubit>().deleteEmployee(employee.id).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Employee Data has been deleted'),
              duration: Duration(seconds: 3),
              action: SnackBarAction(label: "Undo", onPressed: (){}),
            ),
          );
        });
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(
          employee.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              employee.role,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              (employee.endDate == "No Date")
                  ? "From ${employee.startDate}"
                  : '${employee.startDate} - ${employee.endDate}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class Employee {
  int id;
  final String name;
  final String role;
  final String startDate;
  final String endDate;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
  });
}
