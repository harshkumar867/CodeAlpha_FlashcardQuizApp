import 'package:flutter/material.dart';

void main() {
  runApp(FlashcardApp());
}

class Flashcard {
  String question;
  String answer;
  Flashcard({required this.question, required this.answer});
}

class FlashcardApp extends StatefulWidget {
  @override
  _FlashcardAppState createState() => _FlashcardAppState();
}

class _FlashcardAppState extends State<FlashcardApp> {
  List<Flashcard> flashcards = [
    Flashcard(question: 'What is Flutter?', answer: 'Flutter is an open-source UI toolkit by Google.'),
    Flashcard(question: 'What language does Flutter use?', answer: 'Flutter uses Dart language.'),
    Flashcard(question: 'Who developed Flutter?', answer: 'Google developed Flutter.'),
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  final questionController = TextEditingController();
  final answerController = TextEditingController();

  void nextCard() {
    setState(() {
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
      }
      showAnswer = false;
    });
  }

  void previousCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
      showAnswer = false;
    });
  }

  void addCard(String question, String answer) {
    setState(() {
      flashcards.add(Flashcard(question: question, answer: answer));
      currentIndex = flashcards.length - 1;
    });
  }

  void deleteCard() {
    setState(() {
      if (flashcards.isNotEmpty) {
        flashcards.removeAt(currentIndex);
        if (currentIndex > 0) currentIndex--;
        showAnswer = false;
      }
    });
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: questionController, decoration: InputDecoration(labelText: 'Question')),
            TextField(controller: answerController, decoration: InputDecoration(labelText: 'Answer')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
                  addCard(questionController.text, answerController.text);
                  questionController.clear();
                  answerController.clear();
                }
                Navigator.pop(context);
              },
              child: Text('Add'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var card = flashcards[currentIndex];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flashcard Quiz App'),
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: showAddDialog),
            IconButton(icon: Icon(Icons.delete), onPressed: deleteCard),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Flashcard ${currentIndex + 1} of ${flashcards.length}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    showAnswer ? card.answer : card.question,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() => showAnswer = !showAnswer),
                child: Text(showAnswer ? 'Hide Answer' : 'Show Answer'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: previousCard, child: Text('Previous')),
                  ElevatedButton(onPressed: nextCard, child: Text('Next')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
