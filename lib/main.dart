import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

main(List<String> args) {
  runApp(LiveSearch());
}

class LiveSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppState _app = context.watch<AppState>();
    final items = List<String>.generate(10000, (i) => "Item $i");

    return MaterialApp(
      title: 'LiveSearch Demo',
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                  bottom: 8,
                ),
                padding: EdgeInsets.only(left: 24, right: 8),
                child: TextField(
                  controller: _app.searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    hintText: 'Enter Search Value Here',
                  ),
                ),
              ),
              Container(
                height: 256,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                  bottom: 8,
                ),
                padding: EdgeInsets.only(left: 8, right: 8),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${items[index]}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
