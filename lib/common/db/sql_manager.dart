import 'dart:async';

import 'package:sqflite/sqflite.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/10/12
 *
 * @Description  数据库管理
 *
 * PS: Stay hungry,Stay foolish.
 */

class SqlManager {
  static final _VERSION = 1;

  static final _NAME = "gsy_github_app_flutter.db";

  static Database _database;

  ///初始化
  static init() async {
    // open the database
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + _NAME;
    _database = await openDatabase(path, version: _VERSION,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      //await db.execute("CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
    });
  }

  /**
   * 表是否存在
   */
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  ///获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  ///关闭
  static close() {
    if (_database != null) {
      _database.close();
      _database = null;
    }
  }
}
