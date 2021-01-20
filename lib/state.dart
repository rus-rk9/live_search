import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppState with ChangeNotifier {
  TextEditingController searchController;
  List<Map<String, dynamic>> searchData = [];

  AppState() {
    searchController = TextEditingController();
    loadData();
  }

  Future<void> loadData() async {
    log('start loadData');

    log('start reading words.txt');
    final List<String> fData =
        (await rootBundle.loadString('assets/words.txt')).split('\n');
    log('rows count: ${fData.length}');

    log('start openDatabase');
    final String tableName = 'search_vals';
    final Database db = await openDatabase(
      join(await getDatabasesPath(), 'live_search.db'),
      version: 1,
    );

    log('start create table');
    await db.execute('drop table if exists $tableName');
    await db.execute('create table $tableName(value text)');

    log('start rawInsert');
    final Batch batch = db.batch();
    for (int i = 0; i < fData.length; i++) {
      batch.rawInsert(
        'insert into search_vals (value) values(?)',
        [fData[i]],
      );
    }
    await batch.commit(noResult: true);

    log('start select query');
    var res = await db.rawQuery('select value from search_vals');
    searchData = res.isNotEmpty ? res : [];
    log('selected rows: ${searchData.length}');

    notifyListeners();
  }

  void log(String s) {
    print('custLog ' + DateTime.now().toString() + ' $s');
  }
}
