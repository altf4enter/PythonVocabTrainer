// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/controller/database_controller.dart';
import 'package:python_vocab_trainer/controller/file_controller.dart';
import 'package:python_vocab_trainer/dbHelper/mongodb.dart';
import 'package:python_vocab_trainer/view/atoms/package_tile.dart';
import 'package:python_vocab_trainer/view/pages/learning_mode_selection.dart';
import 'package:python_vocab_trainer/view/pages/search_packages.dart';

import 'model/package.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  DatabaseController database_controller = DatabaseController();
  FileController file_controller = FileController.instance;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Package> _packages = [];

  @override
  void initState() {
    super.initState();
    //here check if packages have to be updated
    widget.file_controller.getUserPackages().then((List<Package> packages) {
      setState(() {
        packages.sort((pck1,pck2) => pck1.name.compareTo(pck2.name));
        _packages = packages;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Python Vocab Trainer'),
      ),
      body: Scaffold(
        body: ListView(
          children: [
            for (var p in _packages)
              Card(
                child: PackageTile(p, onDelete: () {
                  setState(() {
                    _packages.remove(p);
                  });
                }, onTap: () {
                  showModalBottomSheet(context: context, builder: (context)=>  LearningModeSelection(p));
                }),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchPackagesDelegate(onAdd: (Package p) {
                setState(() {
                  _packages.add(p);
                  _packages.sort((pck1,pck2) => pck1.name.compareTo(pck2.name));
                });
              }),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
