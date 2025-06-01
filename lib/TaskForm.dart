import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:semester_project/database.dart';
import 'package:semester_project/drawer.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController dueTimeController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController assigneeController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController estimatedTimeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController reminderController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController recurrenceController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0324FF),
        title: Row(
          children: [
            Text("Add", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(" Task", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Task Title", titleController, Icons.title, isRequired: true),
              _buildTextField("Description", descriptionController, Icons.description),
              _buildTextField("Due Date", dueDateController, Icons.calendar_today),
              _buildTextField("Due Time", dueTimeController, Icons.access_time),
              _buildTextField("Priority", priorityController, Icons.priority_high),
              _buildTextField("Category", categoryController, Icons.category),
              _buildTextField("Status", statusController, Icons.check_circle),
              _buildTextField("Assignee", assigneeController, Icons.person),
              _buildTextField("Tags", tagsController, Icons.tag),
              _buildTextField("Estimated Time", estimatedTimeController, Icons.timer),
              _buildTextField("Location", locationController, Icons.location_on),
              _buildTextField("Reminder", reminderController, Icons.alarm),
              _buildTextField("Notes", notesController, Icons.note),
              _buildTextField("Recurrence", recurrenceController, Icons.repeat),
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.add_task),
                    label: Text("Add Task"),
                    onPressed: isLoading
                        ? null
                        : () async {
                      setState(() {
                        isLoading = true;
                      });
                      String id = randomAlphaNumeric(5);
                      Map<String, dynamic> taskInfoMap = {
                        "TaskTitle": titleController.text,
                        "Description": descriptionController.text,
                        "DueDate": dueDateController.text,
                        "DueTime": dueTimeController.text,
                        "Priority": priorityController.text,
                        "Category": categoryController.text,
                        "Status": statusController.text,
                        "Assignee": assigneeController.text,
                        "Tags": tagsController.text,
                        "EstimatedTime": estimatedTimeController.text,
                        "Location": locationController.text,
                        "Reminder": reminderController.text,
                        "Notes": notesController.text,
                        "Recurrence": recurrenceController.text,
                        "TaskID": id,
                      };
                      await DatabaseMethods().addTask(taskInfoMap, id);
                      Fluttertoast.showToast(
                        msg: "Task Added Successfully",
                        backgroundColor: Color(0xFF1E1E1E),
                        textColor: Color(0xFF0324FF),
                        toastLength: Toast.LENGTH_SHORT,
                      );
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  if (isLoading) CircularProgressIndicator(color: Color(0xFF0324FF)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE0E0E0)),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          style: TextStyle(fontSize: 16, color: Color(0xFFE0E0E0)),
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: isRequired ? "$label (Required)" : label,
            hintStyle: TextStyle(color: Color(0xFFB0B0B0)),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}