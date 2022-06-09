import 'package:flutter/cupertino.dart';
import 'package:python_vocab_trainer/model/flash_card_element.dart';

class QuizCard extends StatefulWidget{
  FlashcardElement element;
  QuizCard(this.element);
  @override
  State<StatefulWidget> createState() {
    return QuizCardState();
  }
  
}

class QuizCardState extends State<QuizCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
}