import 'package:python_vocab_trainer/model/flash_card_element.dart';
import 'package:python_vocab_trainer/model/func.dart';

class Class extends FlashcardElement {
  List<Func> functions = [];
  List<Func> constructors = [];

  Class.fromJSON(json) : super.fromJSON(json) {
    if (json.containsKey("functions")) {
      for (var f in json["functions"]) {
        f['module_name'] = moduleName;
        functions.add(Func.fromJSON(f));
      }
    }
    if (json.containsKey("constructors")) {
      for (var c in json["constructors"]) {
        c['module_name'] = moduleName;
        functions.add(Func.fromJSON(c));
      }
    }
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> json = {};
    json["name"] = name;
    json["functions"] = [];
    for (var func in functions) {
      json["functions"].add(func.toJSON());
    }
    json["constructors"] = [];
    for (var c in constructors) {
      json["constructors"].add(c.toJSON());
    }
    return json;
  }

  List<Func> getFunctions({skip_internal_funcs=false}){
    if(!skip_internal_funcs){
      return functions;
    }
    List<Func> ret_funcs = [...functions];
    ret_funcs.removeWhere((f) => f.isInternalFunc());
    return ret_funcs;
  }

  void setRelevant(bool rel) {
    super.setRelevant(rel);
    for (var f in functions) f.setRelevant(rel);
    for (var c in constructors) c.setRelevant(rel);
  }

  bool equals(String name2) {
    return name == name2 ? true : false;
  }
}
