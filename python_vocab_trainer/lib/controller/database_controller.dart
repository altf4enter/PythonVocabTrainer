import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:python_vocab_trainer/dbHelper/mongodb.dart';
import 'dart:convert';

import 'package:python_vocab_trainer/model/package.dart';

class DatabaseController {

  static Future<Package> getPackage(package_name) async {
    var json =
        await MongoDatabase.packagesCollection.findOne({"name": package_name});
    return Package.fromJSON(json);
  }

  static Future<List<String>> getPackageSuggestions(query) async {
    List<String> suggestions = [];
    List<Map<String, dynamic>> json = await MongoDatabase.packagesCollection
        .find(where.match("name", "^${query}").limit(10).fields(["name"]))
        .toList();
    json.forEach((element) {
      suggestions.add(element['name'].toString());
    });
    
    if (query.isNotEmpty) {
      suggestions.add("$query");
    }
    return suggestions;
  }

  static Future<List<Package>> getUpdatedPackages()async{
    List<Package> packages = [];
    //TODO gucken wie ich das machen möchte
    return packages;
  }
}
