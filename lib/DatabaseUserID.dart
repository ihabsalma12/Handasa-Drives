import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



class DatabaseUserID{

  Database? myDB;


  Future get instance async{
    if (myDB == null){
      myDB = await initialize();
    }
    return myDB;
  }

  int Version = 1;



  insertUser(String? uid, String? email, String? fullName) async{
    final Database db = await instance;

    var profileInfo = {
      'uid' : uid,
      'email': email,
      'fullName': fullName
    };
    await db.insert('DRIVER_ID', profileInfo, conflictAlgorithm: ConflictAlgorithm.replace);

  }

  //
  // Future<String> retrieveID() async {
  //   final Database db = await myDB;
  //   final List<Map<String, dynamic>> maps = await db.query('DRIVER_ID');
  //   return maps[0]['userID'];
  // }


  removeDB() async{
    String myDBpath = await getDatabasesPath();
    String path = join(myDBpath, 'userfile.db');
    await deleteDatabase(path);
    debugPrint("DRIVER_ID has been deleted.");
  }
  ifExistDB() async{
    String myDBpath = await getDatabasesPath();
    String path = join(myDBpath, 'userfile.db');
    return await databaseExists(path)
        ?
    // { true}
      {debugPrint("DRIVER_ID EXIST")}
        :
    // { false}
    {debugPrint("DRIVER_ID NOT EXIST")}
    ;
  }



  initialize() async{
    String path = join(await getDatabasesPath(), 'userfile.db');
    Database myMainDB = await openDatabase(path, version: Version, onCreate: (db, version){
          db.execute('''
          CREATE TABLE 'DRIVER_ID'(
           'uid' TEXT PRIMARY KEY,
           'email' TEXT NOT NULL,
           'fullName' TEXT NOT NULL
           )
           ''');

          debugPrint("DRIVER_ID has been created!");
        }
    );
    return myMainDB;
  }
}
