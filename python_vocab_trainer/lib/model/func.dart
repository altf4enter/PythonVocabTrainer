import 'package:python_vocab_trainer/model/parameter.dart';

class Func {
  int id = 0;
  String name = "";
  String description = "";

  List<Parameter> parameters = [];
  Parameter returnValue = Parameter.noParameter();

  Func.fromJSON(json){
    name = json["name"];
    id = json["id"];
    description = json["description"];
    if(json.containsKey("parameters")){
      for (String parameter in json["parameters"]){
        parameters.add(Parameter.fromJSON(json["parameter"]));
      }
    }
    returnValue = Parameter.fromJSON(json["returnValue"]);
  }
}