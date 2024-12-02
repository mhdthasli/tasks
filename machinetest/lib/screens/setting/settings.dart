

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },

            child: Icon(Icons.arrow_back, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/image/images (8).jpeg"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Malak Idrissi',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rabat, Morocco',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Fixed: Wrap Container in SizedBox with a fixed width
                SizedBox(
                  width: 60, // Adjust the width as needed
                  child: Container(
                    height: 60, // Adjust the height as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                    ),
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF2E2E3B),
                        radius: 20,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: const Text(
                'Hi! My name is Malak, I’m a community manager from Rabat, Morocco.',
                textAlign: TextAlign.start,

                style: TextStyle(
                    fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold,),
              ),
            ),
            const SizedBox(height: 45),
            const ListTile(
              leading: Icon(Icons.notifications, color: Colors.white),
              title: Text('Notifications', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
            ),
            const ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text('General', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
            ),
            const ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text('Account', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
            ),
            const ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              title: Text('About', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
