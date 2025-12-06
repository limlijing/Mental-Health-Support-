import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class dairy extends StatefulWidget {
  const dairy({super.key});

  @override
  State<dairy> createState() => dairypage();
}

class dairypage extends State<dairy> {
  List<String> entries = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  void loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('journal');
    if (data != null) {
      setState(() {
        entries = List<String>.from(jsonDecode(data));
      });
    }
  }

  void saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('journal', jsonEncode(entries));
  }

  void addEntry() {
    String text = controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      entries.add(text);
      controller.clear();
    });
    saveEntries();
  }

  void deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
    saveEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Diary Records")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Write a new note...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addEntry,
                ),
              ),
            ),
          ),
          Expanded(
            child: entries.isEmpty
                ? const Center(child: Text("No diary entries yet."))
                : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(entries[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteEntry(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
