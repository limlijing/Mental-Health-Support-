// bubble_pop_game.dart
import 'package:flutter/material.dart';
import 'dart:math';

class BubblePopGame extends StatefulWidget {
  @override
  _BubblePopGameState createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame> {
  List<Bubble> _bubbles = [];
  int _poppedCount = 0;
  Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateBubbles();
  }

  void _generateBubbles() {
    _bubbles.clear();
    for (int i = 0; i < 20; i++) {
      _bubbles.add(Bubble(
        x: _random.nextDouble() * 300,
        y: _random.nextDouble() * 500,
        size: 30 + _random.nextDouble() * 40,
        color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
      ));
    }
  }

  void _popBubble(int index) {
    setState(() {
      _bubbles.removeAt(index);
      _poppedCount++;

      if (_bubbles.isEmpty) {
        _generateBubbles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ByeBubble')),
      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[100]!, Colors.lightBlue[50]!],
              ),
            ),
          ),


          for (int i = 0; i < _bubbles.length; i++)
            Positioned(
              left: _bubbles[i].x,
              top: _bubbles[i].y,
              child: GestureDetector(
                onTap: () => _popBubble(i),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: _bubbles[i].size,
                  height: _bubbles[i].size,
                  decoration: BoxDecoration(
                    color: _bubbles[i].color.withOpacity(0.7),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.circle, color: Colors.white70),
                ),
              ),
            ),


          Positioned(
            top: 20,
            right: 20,
            child: Text(
              'bubble die: $_poppedCount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateBubbles,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class Bubble {
  final double x;
  final double y;
  final double size;
  final Color color;

  Bubble({required this.x, required this.y, required this.size, required this.color});
}