import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/model/flash_card_element.dart';
import 'package:python_vocab_trainer/model/package.dart';
import 'package:python_vocab_trainer/view/organisms/flashcard.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FlashcardFlipper extends StatefulWidget {
  Package package;
  int _curr_idx = 0;
  List<FlashcardElement> _flashcardElements = [];

  FlashcardFlipper(this.package) {
    _flashcardElements = package.getFlashcardElements(
      recursive: true,
      only_relevant: true,
      flatten: true,
    );
  }

  List<FlashcardElement> getFlashcardElements() {
    return package.getFlashcardElements(
      recursive: true,
      only_relevant: true,
      flatten: true,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return FlashcardFlipperState();
  }
}

class FlashcardFlipperState extends State<FlashcardFlipper> {
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
               
                height: 400.0,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    widget._curr_idx = index;
                  });
                },
              ),
              items: widget._flashcardElements.map((flashcardElement) {
                return Flashcard(flashcardElement);
              }).toList(),
            ),
            Center(
                child: Text(
                    "${widget._curr_idx + 1}/${widget._flashcardElements.length}")),
            ElevatedButton(
                onPressed: () {
                  FlashcardElement elem =
                      widget._flashcardElements[widget._curr_idx];
                  elem.setRelevant(false);
                  if(widget._curr_idx != widget._flashcardElements.length) carouselController.nextPage();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "${elem.name} is marked as irrelevant.")));
                },
                child: Text("Don't show next time."))
          ]),
    );
  }
}
