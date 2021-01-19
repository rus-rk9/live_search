library app_main;

import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  TextEditingController searchController;
  AppState() {
    searchController = TextEditingController();
  }
}
