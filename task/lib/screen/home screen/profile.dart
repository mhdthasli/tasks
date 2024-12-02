import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.message, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/image/photo-1.jpeg'), // Replace with your asset path
                ),
                const SizedBox(height: 10),
                Text(
                  'Feno Philips',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, color: Colors.green, size: 12),
                    const SizedBox(width: 5),
                    Text(
                      'Present',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Student ID: #23124',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  'Class & Section: 5A',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                buildListTile(Icons.dashboard, 'Dashboard'),
                buildListTile(Icons.language, 'Languages'),
                SwitchListTile(
                  value: true,
                  onChanged: (value) {},
                  title: Text('Switch Child'),
                  secondary: Icon(Icons.swap_horiz),
                ),
                buildListTile(Icons.person, 'Teachers'),
                buildListTile(Icons.lock, 'Privacy Settings'),
                buildListTile(Icons.help, 'Help & Support'),
                buildListTile(Icons.logout, 'Log out'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Switch'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 3,
        selectedItemColor: Colors.teal,
        onTap: (index) {},
      ),
    );
  }

  Widget buildListTile(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // White background
        borderRadius: BorderRadius.circular(10), // Rounded corners with radius 10
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Shadow color
            blurRadius: 5, // Shadow blur radius
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 5), // Optional: space between tiles
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }

}

