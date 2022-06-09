import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/model/class.dart';
import 'package:python_vocab_trainer/model/flash_card_element.dart';
import 'package:python_vocab_trainer/model/func.dart';

class Flashcard extends StatefulWidget {
  FlashcardElement element;
  Flashcard(this.element);
  @override
  State<StatefulWidget> createState() {
    return FlashcardState(element);
  }
}

class FlashcardState extends State<Flashcard> {
  Card getClassFlashcard(Class c) {
    return Card(
      color: Colors.lightBlue[100],
      child: Center(
        child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${c.moduleName}.",
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(c.name),
            //Column(children:c.functions.map((f) => Text(f.getSignature())).toList()),
          ],
        ),
      ),
    );
  }

  Card getFunctionFlashcard(Func f) {
    return Card(
      color: Colors.lightBlue[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${f.moduleName}.",
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text("${f.name} (${f.parameters.map((param) => param.name).join(", ")})"),
          ],
        ),
      ),
    );
  }

  //if (flashcardElement.runtimeType == Func) {
  //return FunctionForm(flashcardElement as Func);

  FlashcardElement element;
  List<Widget> stackChildren = [];
  int i = 0;
  FlashcardState(this.element) {
    stackChildren = [
      Card(
        child: Center(
          child: Text(element.description),
        ),
      ),
      this.element.runtimeType == Func
          ? getFunctionFlashcard(this.element as Func)
          : getClassFlashcard(this.element as Class)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        print("tapped");
        i = (i + 1) % 2;
      }),
      child: stackChildren[i],
    );
  }
}
