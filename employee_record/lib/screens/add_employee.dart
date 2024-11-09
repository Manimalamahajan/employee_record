import 'package:employee_record/cubit/employee_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import "package:intl/intl.dart";
import 'package:flutter/material.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});
  static const routeName = '/add';
  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode(); // FocusNode for TextField
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerRole =
      TextEditingController(); // Controller for TextField
  final FocusNode _focusNode1 = FocusNode(); // FocusNode for TextField
  final TextEditingController _controller1 = TextEditingController();
  final FocusNode _focusNode2 = FocusNode(); // FocusNode for TextField
  final TextEditingController _controller2 = TextEditingController();
  // List of options to display in the bottom sheet
  final List<String> options = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];
  Map args = {};
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      args = ModalRoute.of(context)?.settings.arguments as Map;
      if (args["mode"] == "edit") {
        _controllerName.text = args["name"];
        _controllerRole.text = args["role"];
        _controller1.text = args["startDate"];
        _controller2.text = args["endDate"];
      }
    });
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showBottomSheet();
      }
    });
    _focusNode1.addListener(() {
      if (_focusNode1.hasFocus) {
        _showStartDatePicker();
      }
    });
    _focusNode2.addListener(() {
      if (_focusNode2.hasFocus) {
        _showEndDatePicker();
      }
    });
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }

    return null;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controllerRole.dispose();
    _focusNode1.dispose();
    _controller1.dispose();
    _focusNode2.dispose();
    _controller2.dispose();
    //_focusNode.removeListener((){});
    super.dispose();
  }

  DateTime? _selectedStartDate;

  DateTime? selectedStartDate = DateTime.now();

  DateTime? _selectedEndDate;

  DateTime? selectedEndDate = DateTime.now();

  void _showStartDatePicker() {
    _focusNode1.unfocus();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Shortcut Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShortcutButton("Today", DateTime.now()),
                    _buildShortcutButton(
                        "Next Monday", _nextWeekday(DateTime.monday)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShortcutButton(
                        "Next Tuesday", _nextWeekday(DateTime.tuesday)),
                    _buildShortcutButton("After 1 week",
                        DateTime.now().add(const Duration(days: 7))),
                  ],
                ),
                const SizedBox(height: 16),

                // Calendar
                Center(
                    child: Theme(
                  data: ThemeData(
                    bottomSheetTheme: const BottomSheetThemeData(
                        backgroundColor: Colors.blue),
                    primarySwatch: Colors.blue, // Change header color
                    primaryColor: Colors.blue,
                  ),
                  child: CalendarDatePicker(
                    initialDate: selectedStartDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (date) {
                      setState(() {
                        selectedStartDate = date;
                      });
                    },
                  ),
                )),

                // Selected Date Display

                const SizedBox(height: 16),

                // Cancel and Save Buttons
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMM d, yyyy')
                                .format(selectedStartDate!),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 208, 230, 242),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Square corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10), // Size of the square button
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        )),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, selectedStartDate);
                          if (selectedStartDate != null &&
                              selectedStartDate != _selectedStartDate) {
                            setState(() {
                              _selectedStartDate = selectedStartDate;

                              _controller1.text = DateFormat('MMM d, yyyy').format(
                                  selectedStartDate!); // Update TextFormField with selected date
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Square corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15), // Size of the square button
                        ),
                        child: const Text("Save",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper function to create shortcut buttons
  Widget _buildShortcutButton(String text, DateTime date) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 2.5,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedStartDate = date;
            
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 208, 230, 242),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Square corners
          ),
          //padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.blue,fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildShortcutButtonEnd(String text, DateTime? date) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 2.5,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (date == null) {
              selectedEndDate = date;
            } else {
              selectedEndDate = date;
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 208, 230, 242),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Square corners
          ),
          //padding: EdgeInsets.symmetric(vertical: 10,horizontal: 18),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.blue,fontSize: 12),
        ),
      ),
    );
  }

  // Function to calculate the next occurrence of a specific weekday
  DateTime _nextWeekday(int weekday) {
    DateTime date = DateTime.now();
    while (date.weekday != weekday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  void _showEndDatePicker() {
    _focusNode2.unfocus();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Shortcut Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShortcutButtonEnd("No Date", null),
                    _buildShortcutButtonEnd("Today", DateTime.now()),
                  ],
                ),

                const SizedBox(height: 16),

                // Calendar
                Center(
                    child: Theme(
                  data: ThemeData(
                    bottomSheetTheme: const BottomSheetThemeData(
                        backgroundColor: Colors.blue),
                    primarySwatch: Colors.blue, // Change header color
                  ),
                  child: CalendarDatePicker(
                    initialDate: selectedEndDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (date) {
                      setState(() {
                        selectedEndDate = date;
                      });
                    },
                  ),
                )),

                // Selected Date Display

                const SizedBox(height: 16),

                // Cancel and Save Buttons
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMM d, yyyy').format(selectedEndDate!),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 208, 230, 242),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Square corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10), // Size of the square button
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        )),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, selectedEndDate);
                          if (selectedEndDate != null &&
                              selectedEndDate != _selectedEndDate) {
                            setState(() {
                              _selectedEndDate = selectedEndDate;

                              _controller2.text = DateFormat('MMM d, yyyy').format(
                                  selectedEndDate!); // Update TextFormField with selected date
                            });
                          } else {
                            setState(() {
                              _controller2.text = "No Date";
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Square corners
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15), // Size of the square button
                        ),
                        child: const Text("Save",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet() async {
    _focusNode.unfocus();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        options[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        // Update the TextField with the selected option

                        _controllerRole.text = options[index];

                        Navigator.pop(context); // Close the bottom sheet
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
 final Map argsUpdate = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.blue,
          title: argsUpdate["mode"] == "add"
              ? Text(
                  "Add Employee Details",
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  "Edit Employee Details",
                  style: TextStyle(color: Colors.white),
                ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _controllerName,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 13),
                              prefixIcon:
                                  Image.asset('assets/images/person_FILL0.png'),
                              border: const OutlineInputBorder(),
                              labelText: 'Employee name'),
                          keyboardType: TextInputType.name,
                          validator: _validate,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: _controllerRole,
                          focusNode: _focusNode,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 13),
                            prefixIcon:
                                Image.asset('assets/images/work_FILL0.png'),
                            labelText: "Select Role",
                            suffixIcon: Image.asset('assets/images/Vector.png'),
                            border: const OutlineInputBorder(),
                          ),
                          validator: _validate,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 3,
                              child: TextFormField(
                                controller: _controller1,
                                focusNode: _focusNode1,
                                readOnly: false,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 13),
                                  prefixIcon: Image.asset(
                                      'assets/images/event_FILL0.png'),
                                  labelText: "Start Date",
                                  border: const OutlineInputBorder(),
                                ),
                                validator: _validate,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                            const Flexible(
                                child: Icon(
                              Icons.arrow_forward_outlined,
                              color: Colors.blue,
                            )),
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 3,
                              child: TextFormField(
                                controller: _controller2,
                                focusNode: _focusNode2,
                                readOnly: false,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 13),
                                  prefixIcon: Image.asset(
                                      'assets/images/event_FILL0.png'),
                                  labelText: "End Date",
                                  border: const OutlineInputBorder(),
                                ),
                                validator: _validate,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
                Column(
                  children: [
                    const Divider(
                      thickness: 3.0,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 208, 230, 242),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Square corners
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 18), // Size of the square button
                            ),
                            child: const Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 13),
                            )),
                        const SizedBox(
                          width: 10.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (argsUpdate["mode"] == "add") {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pushReplacementNamed(context, '/');
                                  context
                                      .read<EmployeeCubit>()
                                      .addEmployee(
                                          _controllerName.text,
                                          _controllerRole.text,
                                          _controller1.text,
                                          _controller2.text)
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Employee Data has been added'),
                                        duration: Duration(seconds: 3),
                                        action: SnackBarAction(label: "Undo", onPressed: (){}),
                                      ),
                                    );
                                  });
                                }
                              } else {
                                Navigator.pushReplacementNamed(context, '/');
                                context
                                    .read<EmployeeCubit>()
                                    .updateEmployee(
                                        args["id"],
                                        _controllerName.text,
                                        _controllerRole.text,
                                        _controller1.text,
                                        _controller2.text)
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Employee Data has been updated'),
                                      duration: Duration(seconds: 3),
                                      action: SnackBarAction(label: "Undo", onPressed: (){}),
                                    ),
                                  );
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Square corners
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 22), // Size of the square button
                            ),
                            child: const Text("Save",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13)))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
