import 'package:flutter/material.dart';
import 'resultpage.dart';

class emotionaltest extends StatefulWidget {
  const emotionaltest ({super.key});

  @override
  State<emotionaltest> createState() => _EmotionalTestPageState();
}

class _EmotionalTestPageState extends State<emotionaltest> {
  final List<Map<String, Object>> questions = [
    {'question': '1️⃣ How do you feel emotionally today?'},
    {'question': '2️⃣ Is your stress overwhelming or manageable?'},
    {'question': '3️⃣ Do you feel tired or energized?'},
    {'question': '4️⃣ Did you sleep well recently?'},
    {'question': '5️⃣ Do you feel motivated to do your task?'},
    {'question': '6️⃣ Is it easy or hard to concentrate?'},
    {'question': '7️⃣ Do you feel supported by friends/family? '},
    {'question': '8️⃣ How do you feel about yourself?'},
    {'question': '9️⃣ Do you feeling nervous or calm?'},
    {'question': '🔟 Do you feel hopeful about the near future?'},
  ];

  List<int?> answers = List.filled(10, null);

  void submit() {
    if (answers.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all question before you submit 😊')),
      );
      return;
    }

    int score = answers.fold(0, (sum, item) => sum + (item ?? 0));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultPage(score: score)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emotional Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(questions.length, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questions[index]['question'] as String,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      RadioListTile<int>(
                        title: const Text('1. bad'),
                        value: 1,
                        groupValue: answers[index],
                        onChanged: (value) {
                          setState(() {
                            answers[index] = value;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        title: const Text('2. medium'),
                        value: 2,
                        groupValue: answers[index],
                        onChanged: (value) {
                          setState(() {
                            answers[index] = value;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        title: const Text('3. nice'),
                        value: 3,
                        groupValue: answers[index],
                        onChanged: (value) {
                          setState(() {
                            answers[index] = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                ],
              );
            }),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                child: const Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
