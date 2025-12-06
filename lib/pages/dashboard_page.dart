import 'package:flutter/material.dart';
import 'login_page.dart';
import 'emotionaltest.dart';
import 'dairy.dart';
import 'chatbot.dart';
import 'smallgame.dart';
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
     body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.psychology),
              label: const Text("emotional test"),
              onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => emotionaltest()),
              );
              },
              ),
         const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.book),
              label: const Text("dairy records"),
              onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => dairy()),
              );
              },
              ),
         const SizedBox(height:15),
              ElevatedButton.icon(
              icon: const Icon(Icons.library_books),
              label: const Text("AI"),
              onPressed: () {
              Navigator.push(
              context,
                MaterialPageRoute(builder: (context) =>  ChatBot()),
              );
              },
              ),
         const SizedBox(height:15),
                ElevatedButton.icon(
                icon: const Icon(Icons.games),
                label:const Text("overcome stress"),
                onPressed:(){
                 Navigator.push(
                 context,
                 MaterialPageRoute(builder:(context)=> smallgame()),
                 ) ;
                },
                ),
          ]
        )
     )
    );
}
}

