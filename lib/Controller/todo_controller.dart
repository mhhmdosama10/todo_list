import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Model/task_model.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  TextEditingController textController = TextEditingController();

  void addTask(String title) {
    tasks.add(Task(title: title));
    saveTasks();
  }

  void toggleTaskCompletion(int index) {
    tasks[index].isCompleted = !tasks[index].isCompleted;
    tasks.refresh();
    saveTasks();
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskListJson = tasks.map((task) => task.toJson()).toList();
    prefs.setString('tasks', jsonEncode(taskListJson));
  }

  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final decodedTasks = (jsonDecode(tasksString) as List)
          .map((e) => Task.fromJson(e))
          .toList();
      tasks.addAll(decodedTasks);
    }
  }
}
