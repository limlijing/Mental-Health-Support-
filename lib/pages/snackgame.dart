import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({super.key});

  @override
  State<SnakeGamePage> createState() => _SnakeGamePageState();
}

enum Direction { up, down, left, right }

class _SnakeGamePageState extends State<SnakeGamePage> {
  List<Offset> _snake = [const Offset(5, 5)];
  Offset _food = const Offset(10, 10);
  Direction _direction = Direction.right;
  int _score = 0;
  bool _gameOver = false;
  Timer? _gameTimer;
  final Random _random = Random();


  static const int gridSize = 20;
  static const double cellSize = 20.0;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _gameTimer?.cancel();

    setState(() {
      _snake = [const Offset(5, 5)];
      _direction = Direction.right;
      _score = 0;
      _gameOver = false;
    });

    _generateNewFood();

    _gameTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_gameOver) {
        _moveSnake();
      } else {
        timer.cancel();
      }
    });
  }

  void _generateNewFood() {

    Offset newFood;
    int attempts = 0;

    do {
      int x = _random.nextInt(gridSize);
      int y = _random.nextInt(gridSize);
      newFood = Offset(x.toDouble(), y.toDouble());
      attempts++;

      if (attempts > 100) {
        for (int i = 0; i < gridSize; i++) {
          for (int j = 0; j < gridSize; j++) {
            Offset testPos = Offset(i.toDouble(), j.toDouble());
            if (!_snake.contains(testPos)) {
              setState(() {
                _food = testPos;
              });
              return;
            }
          }
        }
        break;
      }
    } while (_snake.contains(newFood));

    setState(() {
      _food = newFood;
    });
  }

  void _moveSnake() {
    if (_gameOver) return;


    Offset newHead = _snake.first;
    switch (_direction) {
      case Direction.up:
        newHead = Offset(newHead.dx, newHead.dy - 1);
        break;
      case Direction.down:
        newHead = Offset(newHead.dx, newHead.dy + 1);
        break;
      case Direction.left:
        newHead = Offset(newHead.dx - 1, newHead.dy);
        break;
      case Direction.right:
        newHead = Offset(newHead.dx + 1, newHead.dy);
        break;
    }


    if (newHead.dx < 0 ||
        newHead.dx >= gridSize ||
        newHead.dy < 0 ||
        newHead.dy >= gridSize ||
        _snake.contains(newHead)) {
      setState(() {
        _gameOver = true;
      });
      return;
    }

    List<Offset> newSnake = [newHead];
    newSnake.addAll(_snake);

    if (newHead == _food) {
      setState(() {
        _score += 10;
        _snake = newSnake;
      });

      _generateNewFood();
    } else {
      newSnake.removeLast();
      setState(() {
        _snake = newSnake;
      });
    }
  }

  void _changeDirection(Direction newDirection) {
    if ((_direction == Direction.up && newDirection == Direction.down) ||
        (_direction == Direction.down && newDirection == Direction.up) ||
        (_direction == Direction.left && newDirection == Direction.right) ||
        (_direction == Direction.right && newDirection == Direction.left)) {
      return;
    }
    _direction = newDirection;
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Snake Game - Relax & Play"),
        backgroundColor: Colors.teal,
        actions: [
          if (_gameOver)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _startGame,
              tooltip: 'Restart Game',
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Score: $_score",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Length: ${_snake.length}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (_gameOver)
                  const Text(
                    "Game Over!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                if (!_gameOver)
                  Text(
                    "Food: (${_food.dx.toInt()}, ${_food.dy.toInt()})",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
              ],
            ),
          ),

          // 游戏说明
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue[50],
            child: const Column(
              children: [
                Text(
                  "Eat the red food to grow longer!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Use arrow buttons to control the snake",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          // 游戏区域
          Expanded(
            child: Center(
              child: Container(
                width: gridSize * cellSize,
                height: gridSize * cellSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 3),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: CustomPaint(
                  painter: _SnakePainter(snake: _snake, food: _food, gameOver: _gameOver),
                ),
              ),
            ),
          ),

          // 控制按钮区域
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Controls",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // 上方向
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_up, size: 32),
                        onPressed: () => _changeDirection(Direction.up),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.teal[100],
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      // 左右方向
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_left, size: 32),
                            onPressed: () => _changeDirection(Direction.left),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.teal[100],
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          const SizedBox(width: 80),
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_right, size: 32),
                            onPressed: () => _changeDirection(Direction.right),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.teal[100],
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                      // 下方向
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                        onPressed: () => _changeDirection(Direction.down),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.teal[100],
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text("Restart"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Back"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _SnakePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset food;
  final bool gameOver;

  _SnakePainter({required this.snake, required this.food, required this.gameOver});

  @override
  void paint(Canvas canvas, Size size) {

    final Paint gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 20; i++) {
      canvas.drawLine(
        Offset(i * 20.0, 0),
        Offset(i * 20.0, 400),
        gridPaint,
      );
      canvas.drawLine(
        Offset(0, i * 20.0),
        Offset(400, i * 20.0),
        gridPaint,
      );
    }

    final Paint foodPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Paint foodShadowPaint = Paint()
      ..color = Colors.red[300]!
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(food.dx * 20 + 10, food.dy * 20 + 10),
        width: 18,
        height: 18,
      ),
      foodShadowPaint,
    );

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(food.dx * 20 + 10, food.dy * 20 + 10),
        width: 16,
        height: 16,
      ),
      foodPaint,
    );

    final Paint snakePaint = Paint()
      ..color = gameOver ? Colors.grey : Colors.teal
      ..style = PaintingStyle.fill;


    for (final segment in snake) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(segment.dx * 20 + 10, segment.dy * 20 + 10),
          width: 16,
          height: 16,
        ),
        snakePaint,
      );
    }

    if (snake.isNotEmpty && !gameOver) {
      final Paint headPaint = Paint()
        ..color = Colors.teal[800]!
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(snake.first.dx * 20 + 10, snake.first.dy * 20 + 10),
          width: 16,
          height: 16,
        ),
        headPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}