import 'package:employee_record/cubit/employee_cubit.dart';
import 'package:employee_record/screens/add_employee.dart';
import 'package:employee_record/screens/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      title: 'Flutter Assignment',
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider(
              create: (context) => EmployeeCubit()..loadEmployeesList(),
              child: const EmployeeListScreen(),
            ),
        '/add': (context) => BlocProvider(
              create: (_) => EmployeeCubit(),
              child: const AddEmployee(),
            )
      },
    );
  }
}
