import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/controller/file_controller.dart';

import 'package:python_vocab_trainer/model/package.dart';

class CustomizeVocabularyPage extends StatefulWidget {
  Package package;
  Map<String, bool> expanded = {};
  CustomizeVocabularyPage(this.package);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomizeVocabularyPageState();
  }
}

class CustomizeVocabularyPageState extends State<CustomizeVocabularyPage> {
  //returns selectable listtiles, not including the expansion list for subpackages
  List<Widget> getPackageListTiles(Package p, {recursion_level = 0}) {
    List<Widget> listTiles = [];
    for (var elem in p.getFlashcardElements()) {
      if (elem.hasDescription()) {
        listTiles.add(CheckboxListTile(
            title: Text("${'  ' * recursion_level}${p.name}.${elem.name}"),
            value: elem.isRelevant,
            onChanged: (bol) {
              setState(() {
                elem.setRelevant(bol == true);
              });
            }));
      } else {
        listTiles.add(ListTile(
          title: Text(
            "${'  ' * recursion_level}${p.name}.${elem.name}",
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Package element description was not found.")));
          },
        ));
      }
    }
    return listTiles;
  }

  //if package has subpackages
  ExpansionPanel get_expansion_panel_rec(Package p, {int recursion_level = 0}) {
    List<Widget> packages_selections =
        getPackageListTiles(p, recursion_level: recursion_level);
    if (!widget.expanded.containsKey(p.id.toHexString())) {
      widget.expanded[p.id.toHexString()] = false;
    }
    if (p.hasOwnPackageElements() || p.hasSubpackages()) {
      return ExpansionPanel(
        isExpanded: widget.expanded[p.id.toHexString()] == true,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return CheckboxListTile(
              value: p.isRelevant,
              onChanged: (bol) {
                setState(() {
                  p.setRelevant(bol == true);
                });
              },
              title: Text("${'  ' * recursion_level}${p.name}"));
        },
        body: Column(children: [
          Column(children: packages_selections),
          p.hasSubpackages()
              ? ExpansionPanelList(
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      widget.expanded[p.subpackages[panelIndex].id
                          .toHexString()] = !isExpanded;
                    });
                  },
                  children: p.subpackages.map((pckg) {
                    return get_expansion_panel_rec(pckg,
                        recursion_level: recursion_level + 1);
                  }).toList())
              : Container()
        ]),
      );
    }
    //TODO fix this
    else {
      return ExpansionPanel(
        isExpanded: false,
        body: Container(),
        headerBuilder: (context, isExpanded) => ListTile(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Module has no elements.")));
            },
            title: Text(
              "${'  ' * recursion_level}${p.name}",
              style: TextStyle(color: Colors.grey),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.expanded.containsKey(widget.package.id.toHexString())) {
      widget.expanded[widget.package.id.toHexString()] = true;
    }
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(children: [
                ExpansionPanelList(
                  children: [
                    get_expansion_panel_rec(widget.package),
                  ],
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      widget.expanded[widget.package.id.toHexString()] =
                          !isExpanded;
                    });
                  },
                ),
              ]),
            ],
          ),
        ),
        persistentFooterButtons: [
          TextButton(
              onPressed: () async {
                FileController.instance.addPackage(widget.package);
                Navigator.pop(context);
              },
              child: Text("Save"))
        ]);
  }
}
