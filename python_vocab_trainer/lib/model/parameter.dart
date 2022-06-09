

import 'package:python_vocab_trainer/model/flash_card_element.dart';

class Parameter extends FlashcardElement {
  String type = "";

  Parameter.fromJSON(json):super.fromJSON(json){
    type = json["type"] ?? "";
  }

  Parameter.noParameter():super.fromJSON({"id":"","name":""}){
    name = "";
    description = "";
    type="";
  }

  Map<dynamic,dynamic> toJSON(){
    var json = super.toJSON();
    json["type"] = type;
    return json;
  }

  bool equals(String name2){
    return name.trim()==name2.trim()? true:false;
  }
}