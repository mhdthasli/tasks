import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login_page.dart';
import '../provider/name_provider.dart';
import '../screens/accounts/account.dart';
import 'cashin.dart';
import 'cashout.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().loadUserName();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedTab = "All";
  double totalCashIn = 0.0;
  double totalCashOut = 0.0;
  double balance = 0.0;
  bool isExpanded = false;

  bool isUpdated = false;
  bool canNavigate = true;
  bool isLoading = false;

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  String emailid = "";

  TextEditingController _searchController = TextEditingController();

  bool isSearchFieldVisible = false;

  bool _isLoading = false;

  void _updateDateRange(String tab) {
    setState(() {
      final now = DateTime.now();
      selectedTab = tab;

      if (selectedTab == "Daily") {
        selectedStartDate = DateTime(now.year, now.month, now.day);
        selectedEndDate = selectedStartDate;
      } else if (selectedTab == "Weekly") {
        selectedStartDate =
            now.subtract(Duration(days: now.weekday - 1)); // Monday
        selectedEndDate = selectedStartDate.add(Duration(days: 6)); // Sunday
        print(
            "Weekly Range -> Start: $selectedStartDate, End: $selectedEndDate");
      } else if (selectedTab == "Yearly") {
        selectedStartDate = DateTime(now.year, 1, 1);
        selectedEndDate = DateTime(now.year, 12, 31);
      } else if (selectedTab == "Custom") {
        // Custom range stays as is.
      } else {
        selectedStartDate = DateTime(2000);
        selectedEndDate = now;
      }
    });
  }

  void _navigateDate(String direction) {
    setState(() {
      if (selectedTab == "Daily") {
        selectedStartDate = direction == "Previous"
            ? selectedStartDate.subtract(Duration(days: 1))
            : selectedStartDate.add(Duration(days: 1));
        selectedEndDate = selectedStartDate;
      } else if (selectedTab == "Weekly") {
        selectedStartDate = direction == "Previous"
            ? selectedStartDate.subtract(Duration(days: 7))
            : selectedStartDate.add(Duration(days: 7));
        selectedEndDate =
            selectedStartDate.add(Duration(days: 6)); // End of the week
        print("Weekly Start: $selectedStartDate, Weekly End: $selectedEndDate");
      } else if (selectedTab == "Yearly") {
        final newYear = direction == "Previous"
            ? selectedStartDate.year - 1
            : selectedStartDate.year + 1;
        selectedStartDate = DateTime(newYear, 1, 1);
        selectedEndDate = DateTime(newYear, 12, 31);
      }
    });
  }

  Widget _displayDateRange() {
    return GestureDetector(
      onTap: () async {
        if (selectedTab == "Custom") {
          final adjustedEndDate = selectedEndDate.isAfter(DateTime.now())
              ? DateTime.now()
              : selectedEndDate;
          final DateTimeRange? pickedDateRange = await showDateRangePicker(
            context: context,
            initialDateRange:
                DateTimeRange(start: selectedStartDate, end: adjustedEndDate),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (pickedDateRange != null) {
            setState(() {
              selectedStartDate = pickedDateRange.start;
              selectedEndDate = pickedDateRange.end;
            });
          }
        }
      },
      child: Text(
        selectedTab == "All"
            ? "All"
            : selectedTab == "Yearly"
                ? "${selectedStartDate.year}"
                : "${DateFormat("dd-MMM-yyyy").format(selectedStartDate)} - ${DateFormat("dd-MMM-yyyy").format(selectedEndDate)}",
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3A4A3D)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userName = context.watch<UserProvider>().userName;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              child: Image.asset("assets/image/Menu (2).png", scale: 1.8),
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xFF3A4A3D),
        title: isSearchFieldVisible
            ? Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                  onChanged: (value) {},
                  // automatically focus when the field is visible
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 5, left: 25),
                child: Center(
                  child: Text(
                    "Cash Book",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
              ),
        actions: [
          IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  isSearchFieldVisible = !isSearchFieldVisible;
                  if (isSearchFieldVisible) {
                    _searchController.clear();
                  } else {}
                });
              }),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFFFFFFFF),
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Container(
        width: 250,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: Drawer(
          backgroundColor: const Color(0xFFFFFFFF),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 91,
                child: DrawerHeader(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFF3A4A3D),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true; // Show loading indicator
                            });

                            // Load the company data before opening the dialog
                            try {
                              // Assuming the company data is fetched here
                            } catch (e) {
                              print("Error fetching company data: $e");
                            } finally {
                              setState(() {
                                isLoading = false; // Hide loading indicator
                              });
                            }

                            // Open the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // String? tempUserName = userName; // Using username instead of companyName

                                return StatefulBuilder(
                                  builder: (context, setDialogState) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        height: 300,
                                        width: 200,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.account_box,
                                                  color: Color(0xFF3A4A3D),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "User Details",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF3A4A3D),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            // You can add other widgets here if needed
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog without making changes
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    // Handle confirm button action here
                                                  },
                                                  child: Text(
                                                    "Confirm",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Text(
                            userName.isNotEmpty
                                ? " $userName" // Show the username dynamically
                                : "Load User Name",
                            // Fallback if username is not available
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        PopupMenuItem(
                            child: Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFFFFFFFF),
                        )),
                      ],
                    )),
              ),
              ListTile(
                leading: Image.asset("assets/image/Search.png"),
                title: const Text(
                  'Summary',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Summary()));
                },
              ),
              ListTile(
                leading: Image.asset("assets/image/Search.png"),
                title: const Text(
                  'Account Summary',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => AccountSummary()));
                },
              ),
              ListTile(
                leading: Image.asset("assets/image/Money exchange.png"),
                title: const Text(
                  'Transaction - All Account',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => TransactionAllaccount()));
                },
              ),
              ListTile(
                leading: Image.asset("assets/image/Group.png"),
                title: const Text(
                  'Accounts',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Account()));
                },
              ),
              ListTile(
                leading: Image.asset("assets/image/Data transfer.png"),
                title: const Text(
                  'Transfer',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Transfer()));
                },
              ),
              ListTile(
                leading: Image.asset("assets/image/Up.png"),
                title: const Text(
                  'Backup and Restore',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => BackupRestorePage()));
                },
              ),
              ListTile(
                leading: Image.asset("assets/image/Setting.png"),
                title: const Text(
                  'Settings',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Settings()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);

                  // After logging out, navigate to LoginPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    _buildTab("All", selectedTab == "All"),
                    const SizedBox(width: 6),
                    _buildTab("Daily", selectedTab == "Daily"),
                    const SizedBox(width: 6),
                    _buildTab("Weekly", selectedTab == "Weekly"),
                    const SizedBox(width: 6),
                    _buildTab("Yearly", selectedTab == "Yearly"),
                    // const SizedBox(width: 6),
                    // _buildTab("Custom", selectedTab == "Custom"),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                child: Container(
                  width: 358, // Overall width
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xFFFFFFFF),
                    border:
                        Border.all(color: const Color(0xFFDADADA), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 38, // Width for back arrow icon
                        child: IconButton(
                          onPressed: canNavigate
                              ? () => _navigateDate("Previous")
                              : null,
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF3A4A3D),
                          ),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (selectedTab != "All" &&
                                selectedTab != "Yearly") ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.calendar_month,
                                color: Color(0xFF3A4A3D),
                                size: 20,
                              )
                            ],

                            // Space between icon and text
                            // Display Date Range or Year
                            _displayDateRange(),

                            // Second Calendar Icon (optional for the end date)
                            if (selectedTab != "Yearly" &&
                                selectedTab != "All") ...[
                              const SizedBox(width: 3), // Space

                              Icon(
                                Icons.calendar_month,
                                color: Color(0xFF3A4A3D),
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        width: 27, // Width for forward arrow icon
                        child: IconButton(
                          onPressed:
                              canNavigate ? () => _navigateDate("Next") : null,
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF3A4A3D),
                          ),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _buildTableHeader(),
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF3A4A3D),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          DateTime? dateTime;
                          try {
                            dateTime = DateTime.now(); // Parse the date
                          } catch (e) {
                            print("Error parsing date: $e");
                            dateTime =
                                DateTime.now(); // Fallback to current date
                          }

                          _buildTableRow("time", dateTime, "cashIn", "cashOut");
                        },
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CashInPage()));
                        //
                        //         .then(
                        //         (_) => getTransaction(
                        //         loggedCompanyId)); // Reload after returning
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF30CB76),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(174, 44)),
                      child: const Text(
                        "Cash In",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CashOutPage()));

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const CashOutPage()))
                        //     .then((_) => getTransaction(
                        //     loggedCompanyId)); // Reload after returning
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC20000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(174, 44)),
                      child: const Text(
                        "Cash Out",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isExpanded ? 160 : 45,
        color: const Color(0xFF3A4A3D),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Image.asset(
                  "assets/image/handler (1).png",
                  height: 30, // Set a specific height
                  width: 30, // Set a specific width
                ),
              ),
              if (isExpanded)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow(
                          "Total Cash In", ":", totalCashIn.toStringAsFixed(2)),
                      _buildSummaryRow("Total Cash Out", ":",
                          totalCashOut.toStringAsFixed(2)),
                      _buildSummaryRow(
                          "Balance", ":", balance.toStringAsFixed(2)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Tab UI for filtering (like "All", "Daily", etc.)
  Widget _buildTab(String tab, bool isSelected) {
    return GestureDetector(
      onTap: () => _updateDateRange(tab),
      child: Container(
        width: 64,
        height: 24,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3A4A3D) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE4E4E4),
          ),
        ),
        child: Center(
          child: Text(
            tab,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF7C7C7C),
            ),
          ),
        ),
      ),
    );
  }

// Table Header
  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        width: 358, // Set width
        height: 26, // Set height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFFFFFFF),
          border: Border.all(color: const Color(0xFFFFFFFF), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 13, right: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 13, right: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Note",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Cash In",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Cash Out",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Table Row

  Widget _buildTableRow(
    String time,
    DateTime dateTime,
    String cashIn,
    String cashOut,
  ) {
    final String formattedDay = DateFormat("EEEE").format(dateTime);
    final String formattedDate = DateFormat("dd-MM-yyyy").format(dateTime);

    DateTime? parsedTime;
    try {
      parsedTime = DateFormat("HH:mm").parse(time);
    } catch (e) {
      print("Error parsing time: $e");
      parsedTime = DateTime.now();
    }

    final String formattedTime = DateFormat("hh:mm a").format(parsedTime!);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () async {},
        child: Container(
          width: 358, // Set width
          height: 64, // Set height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFFFFFFF),
            border: Border.all(
              color: const Color(0xFFFFFFFF),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Date Column
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDay,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF000000),
                        ),
                      ),
                      Text(
                        "$formattedDate  $formattedTime",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Cash In Column
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    cashIn,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                      fontFamily: 'poppins',
                    ),
                  ),
                ),
              ),
              // Cash Out Column
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    cashOut,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'poppins',
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Summary row for Total Cash In, Total Cash Out, Balance
  Widget _buildSummaryRow(String title, String separator, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 10,
            child: Text(
              separator,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
