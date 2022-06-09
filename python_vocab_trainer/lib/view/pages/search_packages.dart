import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/controller/database_controller.dart';
import 'package:python_vocab_trainer/controller/file_controller.dart';
import 'package:python_vocab_trainer/model/package.dart';


class SearchPackagesDelegate extends SearchDelegate {
  var onAdd;
  SearchPackagesDelegate({this.onAdd});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    
    return AlertDialog(
      title: Text("Add Package $query?"),
      actions: [
        TextButton(
            onPressed: () async {
              //TODO and display waiting signal
              //TODO if package not in database, download it from elsewhere
              //try {
              Package p = await DatabaseController.getPackage(query);
              await FileController.instance.addPackage(p);
              onAdd(p);
              //} catch (e) {
                //send 'query' to python backend to decide if query actually is existing package
              //}
              close(context, null);
              //Navigator.pop(context);
            },
            child: Text("Yes")),
        TextButton(
            onPressed: () {
              close(context, null);
              //Navigator.pop(context);
            },
            child: Text("Dismiss")),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: DatabaseController.getPackageSuggestions(query),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        List<String> suggestions = snapshot.data ?? [];
        return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return ListTile(
                title: Text(suggestion),
                onTap: () {
                  query = suggestion;
                  showResults(context);
                },
              );
            });
      },
    );
  }
}
