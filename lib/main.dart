import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux/redux.dart';

import 'package:startup/model/model.dart';
import 'package:startup/redux/actions.dart';

import 'package:startup/redux/reducers.dart';
import 'package:startup/redux/middleware.dart';

import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DevToolsStore<AppState> store = DevToolsStore<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: appStateMiddleware(),
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(InitAction()),
          builder: (BuildContext context, Store<AppState> store) =>
              HomePage(),
        ),
      ),
    );
  }
}