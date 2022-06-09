import 'package:mongo_dart/mongo_dart.dart';

class FlashcardElement {
  String name = "";
  String description = "";
  String fullName = "";
  String moduleName = "";
  ObjectId id = ObjectId();
  List<String> examples  =[];
  bool isRelevant = true;
  
  FlashcardElement.fromJSON(json){
    name = json["name"];
    fullName = json['full_name'] ?? name;
    moduleName = json['module_name'] ?? "";
    if (json.containsKey('isRelevant')) isRelevant = json["isRelevant"] == 'true';
    description = json["description"] ?? "";
    //TODO should every flashcard element really have an id? 
    id = json["_id"] ?? id;
    if (json.containsKey("examples")){
      for (String example in json["examples"]){
        examples.add(example);
      }
    }
  }

  Map<dynamic,dynamic> toJSON(){
    var json = {};
    json["name"] = name;
    json["description"] = description;
    json["id"] = id;
    json["examples"] = examples;
    json["isRelevant"] = isRelevant? 'true':'false';
    return json;
  }

  bool hasDescription(){
    return description.trim().isNotEmpty;
  }

  void setRelevant(bool rel){
    isRelevant = rel;
  }
}