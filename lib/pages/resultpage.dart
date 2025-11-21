import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int score;

  const ResultPage({Key? key, required this.score}) : super(key: key);

  String getEmotionLevel() {
    if (score >= 25) return "Positive !!! 😊";
    if (score >= 18) return "Is okay 🙂";
    if (score >= 12) return "Down mood 😔";
    return "Vey stressful 😢";
  }

  String getSuggestion() {
    if (score >= 25) {
      return "You are in a good emotional state right now，continue to maintain your positive lifestyle！";
    } else if (score >= 18) {
      return "Rest is not a reward;It's a necessity.Relaxing yourself,listening to music or exercise or taking a nap to balance your emotional";
    } else if (score >= 12) {
      return "You don't always have to hold it all together.You can talking to someone or ai to release your back mood ";
    } else {
      return "First of all,you should be happy.Secondly,everything else is secondary.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Score：$score / 30",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                "Emotional Level${getEmotionLevel()}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                getSuggestion(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Return'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
