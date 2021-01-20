import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
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
                  bottom: 2,
                ),
                padding: EdgeInsets.only(left: 16, right: 8),
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
                width: double.infinity,
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
                padding: EdgeInsets.only(
                  left: 8,
                  right: 8,
                ),
                child: (_app.searchData.length > 0)
                    ? ListView.builder(
                        itemCount: _app.searchData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(
                              left: 8,
                              top: 4,
                              bottom: 4,
                              right: 4,
                            ),
                            child: Text(
                                '${_app.searchData[index]['value']}'.trim()),
                          );
                        },
                      )
                    : Center(
                        child: Text('Loading ...'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
