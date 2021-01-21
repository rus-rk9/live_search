import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

/// main app logic
class AppState with ChangeNotifier {
  /// debug flag, enable output
  bool debug;
  TextEditingController searchController;
  final List<Map<String, dynamic>> emptyData = [
    {'value': 'pls, enter some data in the search field above ...'}
  ];
  List<Map<String, dynamic>> searchData;

  /// for show circle progress
  bool isLoading;
  Database _db;

  AppState() {
    searchController = TextEditingController();
    searchData = emptyData;
    debug = true;
    loadData();
  }

  /// load data from file at app start
  Future<void> loadData() async {
    log('start loadData');
    isLoading = true;

    log('start reading words.txt');

    /// getting data from file
    final List<String> fData =
        (await rootBundle.loadString('assets/words.txt')).split('\n');
    log('rows count: ${fData.length}');

    log('start openDatabase');
    final String tableName = 'search_vals';

    /// getting database
    _db = await openDatabase(
      join(await getDatabasesPath(), 'live_search.db'),
      version: 1,
    );
    log('database opened');

    log('start create table');

    /// recreate table
    await _db.execute('drop table if exists $tableName');
    // await _db.execute('attach database ":memory:" AS memdb');
    // await _db.execute('create table memdb.$tableName(value text)');
    await _db.execute('create table $tableName(value text)');
    log('table created');

    log('start rawInsert');

    /// inserting file data to db using batch
    final Batch batch = _db.batch();
    for (int i = 0; i < fData.length; i++) {
      batch.rawInsert(
        'insert into search_vals (value) values(?)',
        [fData[i]],
      );
    }
    await batch.commit(noResult: true);
    log('end rawInsert');

    // log('start create index');
    /// creating index
    // await _db.execute('create index ${tableName}_value on $tableName(value)');
    // log('index created');

    isLoading = false;
    notifyListeners();
    log('end loadData');
  }

  Future<void> filterIt() async {
    log('start filterIt: ${searchController.text}');

    /// if db still not exists
    if (_db == null) {
      log('!!! _db == null');
      return;
    }

    /// getting filter value
    String filterString = searchController.text.trim().toUpperCase();

    /// if string is empty
    if (filterString.length == 0) {
      log('filter is empty');
      searchData = emptyData;
      notifyListeners();
      return;
    }

    log('start filter query $filterString');

    /// run db filter query
    var res = await _db.rawQuery(
      'select value from search_vals where upper(value) like ?',
      ['$filterString%'],
    );
    log('end filter query $filterString');

    /// if filter value still not changed then get results in searchData
    if (filterString == searchController.text.trim().toUpperCase()) {
      log('filter string $filterString not changed during query, - assign results in searchData');
      searchData = res.isNotEmpty ? res : [];
      log('selected rows: ${searchData.length}');

      /// if filter value still not changed then update ui
      if (filterString == searchController.text.trim().toUpperCase()) {
        log('filter string $filterString not changed during assign - update ui');
        notifyListeners();
      }
    }
    log('end filterIt: $filterString');
  }

  void log(String s) {
    if (debug) {
      /// print only in debug mode
      print('custLog ' + DateTime.now().toString() + ' $s');
    }
  }
}
