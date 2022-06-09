import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/model/func.dart';
import 'package:python_vocab_trainer/model/class.dart';
import 'package:python_vocab_trainer/model/package.dart';
import 'package:python_vocab_trainer/view/organisms/function_form.dart';
import 'package:python_vocab_trainer/view/organisms/class_form.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PackageQuiz extends StatefulWidget {
  Package package;
  PackageQuiz(this.package);
  @override
  State<StatefulWidget> createState() {
    return PackageQuizState();
  }
}

class PackageQuizState extends State<PackageQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Expanded(child: CarouselSlider(
          options: CarouselOptions(
            height: 400.0,
            enableInfiniteScroll: false,
            viewportFraction: 1,
          ),
          items: widget.package
              .getFlashcardElements(recursive: true,only_relevant: true)
              .map((flashcardElement) {
            if (flashcardElement.runtimeType == Func) {
              return FunctionForm(flashcardElement as Func);
            } else if (flashcardElement.runtimeType == Class) {
              return ClassForm(flashcardElement as Class);
            }
            return Container();
          }).toList()),
    ));
  }
}
