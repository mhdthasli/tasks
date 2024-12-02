
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


class CashInPage extends StatefulWidget {
  const CashInPage({super.key});

  @override
  State<CashInPage> createState() => _CashInPageState();
}

class _CashInPageState extends State<CashInPage> {
  bool isCashIn = true;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF3A4A3D), // Header background color
            hintColor: const Color(0xFF3A4A3D),  // Selected date circle color
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF3A4A3D), // Header text color
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary, // Button text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF3A4A3D), // Header background color
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF3A4A3D), // Header text and button colors
            ),
            timePickerTheme: TimePickerThemeData(
              dayPeriodColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xFF3A4A3D); // Selected AM/PM color
                }
                return Colors.white!; // Unselected AM/PM color
              }),
              dayPeriodTextColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white; // Text color for selected AM/PM
                }
                return Colors.black; // Text color for unselected AM/PM
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }


  // Helper function to format TimeOfDay to "HH:mm:ss" string

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A4A3D),
        title: const Text(
          "Cash In",
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black,
                    selectedColor: Colors.white,
                    fillColor: const Color(0xFF3A4A3D),
                    borderColor: Colors.black,
                    isSelected: [isCashIn, !isCashIn],
                    onPressed: (index) {
                      setState(() {
                        isCashIn = index == 0;
                      });
                    },
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Cash In"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Cash Out"),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                isCashIn ? "Cash In" : "Cash Out",
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.number,

                controller: _amountController,
                decoration: InputDecoration(
                  labelText: "Enter Amount",
                  prefixIcon: const Icon(FontAwesomeIcons.indianRupeeSign),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF3A4A3D)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: "Notes",
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF3A4A3D)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText:
                            DateFormat("dd-MMM-yyyy").format(selectedDate),
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: selectedTime.format(context),
                            prefixIcon: const Icon(Icons.access_time),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A4A3D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      maximumSize: const Size(174, 44),
                    ),
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   connect().then((onValue) {
                      //     if (onValue) {
                      //       if (loggedCompanyId == 0 || loggedCompanyId == null) {
                      //         Fluttertoast.showToast(
                      //           msg: 'Company ID is not set. Please select a company.',
                      //           toastLength: Toast.LENGTH_SHORT,
                      //           gravity: ToastGravity.BOTTOM,
                      //           fontSize: 16.0,
                      //           backgroundColor: Color(0xFF0A1EBE),
                      //           textColor: Colors.white,
                      //         );
                      //         return;
                      //       }
                      //
                      //       String getFormattedTime(TimeOfDay timeOfDay) {
                      //         final now = DateTime.now();
                      //         final DateTime dateTime = DateTime(
                      //           now.year,
                      //           now.month,
                      //           now.day,
                      //           timeOfDay.hour,
                      //           timeOfDay.minute,
                      //         );
                      //         var timeFormat = DateFormat("hh:mm:ss");
                      //         return timeFormat.format(dateTime);
                      //       }
                      //
                      //       saveTransactionPost(
                      //         isCashIn
                      //             ? Transaction(
                      //           id: 0,
                      //           cashin: double.parse(_amountController.text),
                      //           cashout: 0,
                      //           notes: _notesController.text,
                      //           date: DateFormat('yyyy-MM-dd').format(selectedDate),
                      //           time: getFormattedTime(selectedTime),
                      //           companyid: loggedCompanyId,
                      //         )
                      //             : Transaction(
                      //           id: 0,
                      //           cashin: 0,
                      //           cashout: double.parse(_amountController.text),
                      //           notes: _notesController.text,
                      //           date: DateFormat('yyyy-MM-dd').format(selectedDate),
                      //           time: getFormattedTime(selectedTime),
                      //           companyid: loggedCompanyId,
                      //         ),
                      //       ).then((result) {
                      //         if (result) {
                      //           // Handle transaction saving here
                      //           Fluttertoast.showToast(
                      //             msg: 'Transaction saved successfully',
                      //             backgroundColor: Color(0xFF0A1EBE),
                      //             textColor: Colors.white,
                      //
                      //             gravity: ToastGravity.BOTTOM,
                      //
                      //             fontSize: 16.0,
                      //           );
                      //           getTransaction();
                      //           Navigator.pop(context);
                      //         } else {
                      //           Fluttertoast.showToast(
                      //             msg: 'Transaction failed',
                      //             // toastLength: Toast.LENGTH_SHORT,
                      //             gravity: ToastGravity.BOTTOM_LEFT,
                      //             fontSize: 16.0,
                      //             backgroundColor: Color(0xFF0A1EBE),
                      //             textColor: Colors.white,
                      //           );
                      //         }
                      //       });
                      //     } else {
                      //       Fluttertoast.showToast(
                      //         msg: 'Connection failed',
                      //         toastLength: Toast.LENGTH_SHORT,
                      //         gravity: ToastGravity.BOTTOM,
                      //         backgroundColor: Color(0xFF0A1EBE),
                      //         textColor: Colors.white,
                      //
                      //         fontSize: 16.0,
                      //       );
                      //     }
                      //   });
                      // } else {
                      //   Fluttertoast.showToast(
                      //     msg: 'Please fill in all fields',
                      //     toastLength: Toast.LENGTH_SHORT,
                      //     gravity: ToastGravity.BOTTOM,
                      //     fontSize: 16.0,
                      //     backgroundColor: Color(0xFF0A1EBE),
                      //     textColor: Colors.white,
                      //   );
                      // }

                    },


                    child: const Text(
                      "Save and Exit",
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A4A3D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      maximumSize: const Size(174, 44),
                    ),
                    onPressed: () {

                      // if (_formKey.currentState!.validate()) {
                      //   connect().then((onValue) {
                      //     if (onValue) {
                      //
                      //
                      //       if (loggedCompanyId == 0 || loggedCompanyId == null){
                      //
                      //         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Company ID is not set. Please select a company.')));
                      //
                      //         Fluttertoast.showToast(
                      //           msg: 'Company ID is not set. Please select a company.',
                      //           toastLength: Toast.LENGTH_SHORT,
                      //           gravity: ToastGravity.BOTTOM,
                      //           fontSize: 16.0,
                      //           backgroundColor: Color(0xFF0A1EBE),
                      //           textColor: Colors.white,
                      //         );
                      //         return;
                      //       }
                      //
                      //       String getFormattedTime(TimeOfDay timeOfDay) {
                      //         final now = DateTime.now();
                      //         final DateTime dateTime = DateTime(
                      //             now.year,
                      //             now.month,
                      //             now.day,
                      //             timeOfDay.hour,
                      //             timeOfDay.minute);
                      //         var timeFormat = DateFormat("hh:mm:ss");
                      //         return timeFormat.format(dateTime);
                      //       }
                      //
                      //       saveTransactionPost(
                      //         isCashIn
                      //             ? Transaction(
                      //           id: 0,
                      //           cashin: double.parse(_amountController.text),
                      //           cashout: 0,
                      //           notes: _notesController.text,
                      //           date: DateFormat('yyyy-MM-dd')
                      //               .format(selectedDate),
                      //           time: getFormattedTime(selectedTime),
                      //           companyid: loggedCompanyId,
                      //         )
                      //             : Transaction(
                      //           id: 0,
                      //           cashin: 0,
                      //           cashout: double.parse(_amountController.text),
                      //           notes: _notesController.text,
                      //           date: DateFormat('yyyy-MM-dd')
                      //               .format(selectedDate),
                      //           time: getFormattedTime(selectedTime),
                      //           companyid: loggedCompanyId,
                      //         ),
                      //       ).then((result) {
                      //         if (result) {
                      //
                      //           _notesController.clear();
                      //           _amountController.clear();
                      //
                      //           // ScaffoldMessenger.of(context).showSnackBar(
                      //           //   SnackBar(
                      //           //       content: Text(
                      //           //           'Transaction saved successfully')),
                      //           // );
                      //
                      //
                      //           Fluttertoast.showToast(
                      //             msg: 'Transaction saved successfully',
                      //             toastLength: Toast.LENGTH_SHORT,
                      //             gravity: ToastGravity.BOTTOM,
                      //             fontSize: 16.0,
                      //             backgroundColor: Color(0xFF0A1EBE),
                      //             textColor: Colors.white,
                      //           );
                      //
                      //
                      //
                      //
                      //
                      //         } else {
                      //           // ScaffoldMessenger.of(context).showSnackBar(
                      //           //   SnackBar(
                      //           //     content: Text('Transaction failed'),
                      //           //   ),
                      //           // );
                      //           Fluttertoast.showToast(
                      //             msg: 'Transaction failed',
                      //             toastLength: Toast.LENGTH_SHORT,
                      //             gravity: ToastGravity.BOTTOM,
                      //             fontSize: 16.0,
                      //             backgroundColor: Color(0xFF0A1EBE),
                      //             textColor: Colors.white,
                      //           );
                      //
                      //         }
                      //       });
                      //     } else {
                      //       // ScaffoldMessenger.of(context).showSnackBar(
                      //       //   SnackBar(content: Text('Connection failed')),
                      //       // );
                      //       Fluttertoast.showToast(
                      //         msg: 'Connection failed',
                      //         toastLength: Toast.LENGTH_SHORT,
                      //         gravity: ToastGravity.BOTTOM,
                      //         fontSize: 16.0,
                      //         backgroundColor: Color(0xFF0A1EBE),
                      //         textColor: Colors.white,
                      //       );
                      //     }
                      //   });
                      // } else {
                      //   // ScaffoldMessenger.of(context).showSnackBar(
                      //   //   const SnackBar(
                      //   //       content: Text('Please fill in all fields')),
                      //   // );
                      //
                      //   Fluttertoast.showToast(
                      //     msg: 'Please fill in all fields',
                      //     toastLength: Toast.LENGTH_SHORT,
                      //     gravity: ToastGravity.BOTTOM,
                      //     fontSize: 16.0,
                      //     backgroundColor: Color(0xFF0A1EBE),
                      //     textColor: Colors.white,
                      //   );
                      //
                      // }



                    },
                    child: const Text(
                      "Save and Continue",
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
