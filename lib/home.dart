import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:semester_project/TaskForm.dart';
import 'package:semester_project/database.dart';
import 'package:semester_project/drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Stream? taskStream;
  bool isLoading = false;

  getTaskLoad() async {
    taskStream = await DatabaseMethods().getTaskData();
    setState(() {});
  }

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

  @override
  void initState() {
    getTaskLoad();
    super.initState();
  }

  Widget allTaskDetails() {
    return StreamBuilder(
      stream: taskStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Color(0xFF0324FF)));
        }
        if (!snapshot.hasData) {
          return Center(child: Text("No tasks found", style: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0))));
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            bool isHighPriority = ds["Priority"].toString().toLowerCase() == "high";
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: isHighPriority ? BorderSide(color: Color(0xFF0324FF), width: 2) : BorderSide.none,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Title: ${ds["TaskTitle"]}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Color(0xFF0324FF)),
                                onPressed: () {
                                  titleController.text = ds["TaskTitle"];
                                  descriptionController.text = ds["Description"];
                                  dueDateController.text = ds["DueDate"];
                                  dueTimeController.text = ds["DueTime"];
                                  priorityController.text = ds["Priority"];
                                  categoryController.text = ds["Category"];
                                  statusController.text = ds["Status"];
                                  assigneeController.text = ds["Assignee"];
                                  tagsController.text = ds["Tags"];
                                  estimatedTimeController.text = ds["EstimatedTime"];
                                  locationController.text = ds["Location"];
                                  reminderController.text = ds["Reminder"];
                                  notesController.text = ds["Notes"];
                                  recurrenceController.text = ds["Recurrence"];
                                  editTaskDetail(ds["TaskID"]);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await DatabaseMethods().deleteTask(ds['TaskID']);
                                  Fluttertoast.showToast(
                                    msg: "Task Deleted Successfully",
                                    backgroundColor: Color(0xFF1E1E1E),
                                    textColor: Color(0xFF0324FF),
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text("Due Date: ${ds["DueDate"]}", style: TextStyle(fontSize: 16, color: Color(0xFFE0E0E0))),
                      Text("Priority: ${ds["Priority"]}", style: TextStyle(fontSize: 16, color: Color(0xFFE0E0E0))),
                      SizedBox(height: 8),
                      Text(
                        "Other fields (Description, Status, etc.) available in edit view",
                        style: TextStyle(fontSize: 14, color: Color(0xFFB0B0B0)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0324FF),
        title: Row(
          children: [
            Text("Task", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(" List", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0324FF),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        elevation: 8,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskForm()),
          );
        },
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: allTaskDetails(),
          ),
          if (isLoading) Center(child: CircularProgressIndicator(color: Color(0xFF0324FF))),
        ],
      ),
    );
  }

  Future editTaskDetail(String id) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Task",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
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
                    icon: Icon(Icons.save),
                    label: Text("Update"),
                    onPressed: isLoading
                        ? null
                        : () async {
                      setState(() {
                        isLoading = true;
                      });
                      Map<String, dynamic> taskUpdateMap = {
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
                      await DatabaseMethods().updateTask(id, taskUpdateMap);
                      Fluttertoast.showToast(
                        msg: "Task Updated Successfully",
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
    ),
  );

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