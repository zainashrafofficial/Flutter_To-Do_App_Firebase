import 'package:flutter/material.dart';
import 'package:semester_project/TaskForm.dart';
import 'package:semester_project/home.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF0324FF),
            ),
            child: Text(
              'TaskMaster',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list, color: Color(0xFF0324FF)),
            title: Text('Task List', style: TextStyle(fontSize: 18, color: Color(0xFFE0E0E0))),
            hoverColor: Color(0xFF2A2A2A),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name != '/task_list') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskList()),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.add_task, color: Color(0xFF0324FF)),
            title: Text('Add Task', style: TextStyle(fontSize: 18, color: Color(0xFFE0E0E0))),
            hoverColor: Color(0xFF2A2A2A),
            onTap: () {
              if (ModalRoute.of(context)?.settings.name != '/task_form') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskForm()),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}