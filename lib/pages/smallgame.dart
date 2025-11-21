import 'package:flutter/material.dart';
import 'snackgame.dart';
import 'byebubble.dart';

class smallgame extends StatelessWidget{
  const smallgame ({super.key});
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Play some game"),),
          body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
      ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SnakeGamePage()),
        );
      },
            child: const Text("snackgame"),
      ),
            ElevatedButton(
              onPressed:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BubblePopGame()),
                );
              },
                  child: const Text("bubble game"),
                ),
          ],
      ),
          ),
    );
  }
}


