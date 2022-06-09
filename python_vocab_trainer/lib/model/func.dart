import 'package:python_vocab_trainer/model/parameter.dart';
import 'package:python_vocab_trainer/model/flash_card_element.dart';

class Func extends FlashcardElement{
  List<Parameter> parameters = [];
  Parameter returnValue = Parameter.noParameter();

  Func.fromJSON(json):super.fromJSON(json){
    description = json["description"]?? "";
    if(json.containsKey("parameters")){
      for (var parameter in json["parameters"]){
        parameters.add(Parameter.fromJSON(parameter));
      }
    }
    if(json.containsKey("returnValue")){
      returnValue = Parameter.fromJSON(json["returnValue"]);
    }
  }

  bool isInternalFunc(){
    final regex = RegExp(r'^_[a-z0-9]');
    return regex.hasMatch(name);
  }

  String getSignature(){
    return "$name (${parameters.map((p) => p.name).join(", ")})";
  }

  Map<dynamic,dynamic> toJSON(){
    var json = super.toJSON();
    var params = [];
    for (var p in parameters){
      params.add(p.toJSON());
    }
    json["parameters"] = params;
    return json;
  }

  bool equals(String name2){
    return name == name2? true:false;
  }


}