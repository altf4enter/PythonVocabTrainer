import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:python_vocab_trainer/model/package.dart';

class FileController {
  // Makes this a singleton class, as we want only want a single
  // instance of this object for the whole application
  FileController._privateConstructor();
  static final FileController instance = FileController._privateConstructor();

  Future<File> _getFile(filename) async {
    final _directory = await getApplicationDocumentsDirectory();
    final _path = _directory.path;
    return File('$_path/$filename');
  }

  Future<void> addPackage(Package p) async  {
    File f = await _getFile("packages/${p.name}.json");
    //recursive will create packages dir if not existing
    f.create(recursive:true);
    f.writeAsString(json.encode(p.toJSON()));
  }

  Future<void> removePackage(Package p) async  {
    File f = await _getFile("packages/${p.name}.json");
    f.delete();
  }

  Future<List<Package>> getUserPackages() async {
    List<Package> packages = [];
    final _directory = await getApplicationDocumentsDirectory();
    final _path = _directory.path;
    Directory package_dir = Directory("$_path/packages");
    await package_dir.create();
    List<FileSystemEntity> entities = await package_dir.list().toList();
    Iterable<File> files = entities.whereType<File>();
    for(var f in files){
      String filecontent = await f.readAsString();
      var jsn = json.decode(filecontent);
      packages.add(Package.fromJSON(jsn));
    }
    return packages;
  }
}