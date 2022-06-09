import 'dart:developer';

import 'package:python_vocab_trainer/dbHelper/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';


//TODO add network access to user?
class MongoDatabase {
  static var db, packagesCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    packagesCollection = db.collection(PACKAGES_COLLECTION);
  }

  static dropPackage(package_id) async {
    await packagesCollection.remove({'_id': package_id});
  }
}