import 'package:mongo_dart/mongo_dart.dart';
import 'package:python_vocab_trainer/model/class.dart';
import 'package:python_vocab_trainer/model/func.dart';
import 'package:python_vocab_trainer/model/flash_card_element.dart';

class Package {
  String name = "";
  ObjectId id = ObjectId();
  List<Package> subpackages = [];
  List<Func> functions = [];
  List<Class> classes = [];
  DateTime updated = DateTime.parse("1990-08-16T11:00:00.000Z");
  bool isRelevant = true;

  Package.fromJSON(json) {
    name = json["name"];
    if (json.containsKey('isRelevant'))
      isRelevant = json["isRelevant"] == 'true';
    if (json.containsKey("updated")) {
      updated = DateTime.parse(json['updated']);
    }
    //TODO subpackages have no id, maybe necessary?
    id = json["_id"] ?? id;
    if (json.containsKey("functions")) {
      for (var func in json["functions"]) {
        functions.add(Func.fromJSON(func));
      }
    }
    if (json.containsKey("classes")) {
      for (var cls in json["classes"]) {
        classes.add(Class.fromJSON(cls));
      }
    }
    if (json.containsKey("packages")) {
      for (var cls in json["packages"]) {
        subpackages.add(Package.fromJSON(cls));
      }
    }
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> json = {};
    json["name"] = name;
    json["functions"] = [];
    json["isRelevant"] = isRelevant ? 'true' : 'false';
    for (var func in functions) {
      json["functions"].add(func.toJSON());
    }
    json["classes"] = [];
    for (var c in classes) {
      json["classes"].add(c.toJSON());
    }
    json["packages"] = [];
    for (var p in subpackages) {
      json["packages"].add(p.toJSON());
    }
    json['updated'] = updated.toUtc().toString();
    return json;
  }

  void setRelevant(bool relevant) {
    isRelevant = relevant;
    for (var f in getFlashcardElements()) {
      f.setRelevant(relevant);
    }
    for (var p in subpackages) {
      p.setRelevant(relevant);
    }
  }

  bool hasSubpackages() {
    return subpackages.isNotEmpty;
  }

  bool hasFunctions() {
    return functions.isNotEmpty;
  }

  bool hasClasses() {
    return classes.isNotEmpty;
  }

  bool hasOwnPackageElements() {
    return hasClasses() || hasFunctions();
  }

  List<Func> getFunctions(
      {bool recursive = false, bool hide_internal_functions = false}) {
    List<Func> functions_rec = [...functions];
    if (hide_internal_functions) {
      functions_rec.removeWhere((f) => f.isInternalFunc());
    }
    if (recursive) {
      for (var pck in subpackages) {
        functions_rec.addAll(pck.getFunctions(
          recursive: recursive,
          hide_internal_functions: hide_internal_functions,
        ));
      }
    }
    return functions_rec;
  }

  List<Class> getClasses(
      {bool recursive = false}) {
    List<Class> classes_rec = [...classes];
    if (recursive) {
      for (var pck in subpackages) {
        classes_rec.addAll(pck.getClasses(recursive: recursive));
      }
    }
    return classes_rec;
  }

//recursion means also to get flashcard elements of all subpackages
//flatten means to get nested flashcard elements like functions in classes flattened
  List<FlashcardElement> getFlashcardElements(
      {bool recursive = false,
      bool flatten = false,
      bool only_relevant = false}) {
    List<FlashcardElement> flashcardElements = [];
    for (var f in getFunctions(recursive: recursive)) {
      if (only_relevant) {
        if (f.hasDescription()) {
          if (f.isRelevant) flashcardElements.add(f as FlashcardElement);
        }
      } else {
        flashcardElements.add(f as FlashcardElement);
      }
    }
    for (var c in getClasses(recursive: recursive)) {
      if (only_relevant) {
        if (c.hasDescription()) {
          if (c.isRelevant) flashcardElements.add(c as FlashcardElement);
        }
      } else {
        flashcardElements.add(c as FlashcardElement);
      }
      if (flatten) {
        for (var f in c.functions) {
          Func f_new = Func.fromJSON(f.toJSON());
          f_new.name = c.name + "." + f_new.name;
          if (only_relevant) {
            if (f_new.hasDescription()) {
              if (f_new.isRelevant)
                flashcardElements.add(f_new as FlashcardElement);
            }
          } else {
            flashcardElements.add(f_new as FlashcardElement);
          }
        }
      }
    }
    return flashcardElements;
  }
}
