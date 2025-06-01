import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addTask(Map<String, dynamic> taskMap, String id) async {
    return await FirebaseFirestore.instance.collection("Tasks").doc(id).set(taskMap);
  }

  Future<Stream<QuerySnapshot>> getTaskData() async {
    return await FirebaseFirestore.instance.collection("Tasks").snapshots();
  }

  Future updateTask(String id, Map<String, dynamic> updateMap) async {
    return await FirebaseFirestore.instance.collection("Tasks").doc(id).update(updateMap);
  }

  Future deleteTask(String id) async {
    return await FirebaseFirestore.instance.collection("Tasks").doc(id).delete();
  }
}