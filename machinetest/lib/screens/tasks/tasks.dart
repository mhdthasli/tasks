

import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Map<String, bool> tasks = {
    "10 min Running": true,
    "5 min Rope Skipping": true,
    "10 Push ups": false,
    "10 Pull ups": false,
    "20 Squads": false,
    "30 Jump": false,
    "Lose 20 Kg": false,
    "Reach 50 Push ups": false,
    "Reach 15 min Rope Skipping": false,
    "Reach 100 Squads": false,
    "Lose 10 Kg": false,
    "Reach 100 Push ups": false,
    "Reach 20 min Rope Skipping": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2C),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF1E1E2C),
        title: Text("Sports",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back,color: Colors.white,)),
        actions: [IconButton(icon: Icon(Icons.search,color: Colors.white,), onPressed: () {})],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSection("Today", ["10 min Running", "5 min Rope Skipping",],),
          _buildSection("Tomorrow", ["10 Push ups", "10 Pull ups", "20 Squads", "30 Jump"]),
          _buildSection("Fri, Oct 04, 2023", ["Lose 20 Kg", "Reach 50 Push ups", "Reach 15 min Rope Skipping", "Reach 100 Squads"]),
          _buildSection("Wed, Jan 01, 2026", ["Lose 10 Kg", "Reach 100 Push ups", "Reach 20 min Rope Skipping"]),
        ],
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(Icons.add,color: Color(0xFF1E1E2C),),
      ),
    );
  }

  Widget _buildSection(String title, List<String> taskKeys) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ...taskKeys.map((task) => CheckboxListTile(
          title: Text(task, style: TextStyle(color: Colors.white60)),
          value: tasks[task],
          onChanged: (value) {
            setState(() {
              tasks[task] = value!;
            });
          },
          activeColor: Colors.green,
          checkColor: Colors.white,
          controlAffinity: ListTileControlAffinity.leading,
        )),
      ],
    );
  }
}
