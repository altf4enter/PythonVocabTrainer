import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/model/package.dart';
import 'package:python_vocab_trainer/view/pages/customize_vocabulary.dart';
import 'package:python_vocab_trainer/view/pages/flashcard_flipper.dart';
import 'package:python_vocab_trainer/view/pages/package_listing.dart';
import 'package:python_vocab_trainer/view/pages/package_quiz.dart';

class LearningModeSelection extends StatefulWidget {
  Package package;
  LearningModeSelection(this.package);
  @override
  State<StatefulWidget> createState()=> LearningModeSelectionState();
}

class LearningModeSelectionState extends State<LearningModeSelection>{
  @override
  Widget build(BuildContext context) {
    
    return  ListView(
        children: [
          Card(child: ListTile(
            leading: Icon(Icons.style),
            title: Text("Flash Card flipping"),
            subtitle: Text("Take a look at the descriptions and guess the python element that is described."),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FlashcardFlipper(widget.package)),
              );
            },
          ),),
          Card(child: ListTile(
            leading: Icon(Icons.list),
            title: Text("Fill in the gaps"),
            subtitle: Text("Take a quiz on the functions, classes and parameters by their description."),
            onTap: (){
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => PackageQuiz(widget.package)),
              // );
            },
            
          )),
           Card(child: ListTile(
            leading: Icon(Icons.bookmark),
            title: Text("Show full list of Package elements"),
            subtitle: Text("Listing of all functions and classes of the package."),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PackageListing(widget.package)),
              );
            },
          )),
          Card(child: ListTile(
            leading: Icon(Icons.remove_circle_outline),
            title: Text("Customize the vocabulary"),
            subtitle: Text("Mark irrelevant vocabulary, so that it is not shown while learning."),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomizeVocabularyPage(widget.package)),
              );
            }
          ))
        ],
      )   
    ;
  }
  
}