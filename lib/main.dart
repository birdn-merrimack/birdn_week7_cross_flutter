import 'package:word_generator/word_generator.dart';
import 'package:grammer/grammer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:math';

void main() {
  // https://pub.dev/packages/word_generator

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 74, 140, 184)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // Word Generator: https://pub.dev/packages/word_generator/example
  static String getSentence(){
    final wordGen = WordGenerator();
    // Output string
    String sentence = "";
    // https://dart-tutorial.com/dart-how-to/generate-random-number-in-dart/
    final Random random = Random();
    int question = random.nextInt(2);
    // Not a question
    if (question == 0) {
      // Get 3 verbs
      List<String> verbs = wordGen.randomVerbs(3);
      // I want 1 past tense, 1 present tense, and 1 gerund: https://pub.dev/packages/grammer
      // Change the tense of the first generated verb
      verbs[0] = verbs[0].toPast();
      // Change the verb of the third verb
      verbs[2] = verbs[2].toGerund();
      // Nice, that was cool :)
      // Get 2 name2
      List<String> names = wordGen.randomNames(2);
      // Get 3 nouns
      List<String> nouns = wordGen.randomNouns(3);
      String pluralNoun = nouns[1].toString().toPlural()[0];
      //String creation: https://api.flutter.dev/flutter/dart-core/String-class.html
      sentence = "${names[0]} ${verbs[0]} to ${verbs[1]} the $pluralNoun of the ${nouns[0]} with ${names[1]} who was ${verbs[2]} with the ${nouns[2]}.";
    } else {
      // Yes, a question
      sentence = "Did ${wordGen.randomName()} really ${wordGen.randomVerb()} that ${wordGen.randomNoun()}?";
    } 
  return sentence;
  }

  String sentence = getSentence();
  // Tutorial wants me to add this.
  void getNext() {
    sentence = getSentence();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // Get 'sentence' variable from MyAppState
    var sentence = appState.sentence;

    return Scaffold(
      body: Column(
        children: [
          Text('Word Pairs are boring\nTo prove this point:'),
          BigCard(sentence: sentence), // refer to the 'sentence' varaible

        // Tutorial wants me to add an "elevated" button
        ElevatedButton(
          onPressed: () {
            // I feel fairly sassy today.
            print("Wow! Good job! You pressed a button! 🎉");
            // Yaay, let's get another boring "word pair"`
            // call getNext() from 'MyAppState'
            appState.getNext(); 
          },
          child: Text("Next"),
        )
        ],
      ),
    );
  }
}
// I want things centered https://api.flutter.dev/flutter/widgets/Center/Center.html

// Big card...?
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.sentence
  });
  
  final String sentence;
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
      //https://www.geeksforgeeks.org/flutter-determine-the-height-and-width-of-the-screen/
        padding: const EdgeInsets.all(20),
        child: Text(
          sentence,
          style: style
          ),
      ),
    );
  }
}
