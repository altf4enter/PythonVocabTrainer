import 'package:python_vocab_trainer/model/class.dart';
import 'package:python_vocab_trainer/model/func.dart';

class Package {
  String name = "";
  int id = 0;
  List<Package> subpackages = [];
  List<Func> functions = [];
  List<Class> classes = [];

  Package.fromJSON(json){
    name = json["name"];
    id = json["id"];
    if(json.containsKey("functions")){
      for (String func in json["functions"]){
        functions.add(Func.fromJSON(func));
      }
    }
    if(json.containsKey("classes")){
      for (String cls in json["class"]){
        functions.add(Func.fromJSON(cls));
      }
    }
  }
}