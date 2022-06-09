import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:python_vocab_trainer/controller/database_controller.dart';
import 'package:python_vocab_trainer/controller/file_controller.dart';
import 'package:python_vocab_trainer/dbHelper/mongodb.dart';
import 'package:python_vocab_trainer/model/package.dart';

class PackageTile extends StatefulWidget {
  Package _package ;
  var onTap;
  var onDelete;
  PackageTile(this._package,{this.onTap,this.onDelete});
  @override
  State<StatefulWidget> createState()=> PackageTileState();
  
}

class PackageTileState extends State<PackageTile>{
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: GestureDetector(child: Text("${widget._package.name}"),
      onTap:  widget.onTap ?? (){},
      ),
      
      trailing: GestureDetector(
        onTap: ()async {
          await FileController.instance.removePackage(widget._package);
          widget.onDelete();
        },
        child: Icon(Icons.delete)
      ),
    );
  }
  
}