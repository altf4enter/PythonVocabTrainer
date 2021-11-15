class Parameter {
  String name = "";
  String description = "";
  String type = "";

  Parameter.fromJSON(json){
    name = json["name"];
    description = json["description"] ?? "";
    type = json["type"] ?? "";
  }

  Parameter.noParameter(){
    name = "";
    description = "";
    type="";
  }
}