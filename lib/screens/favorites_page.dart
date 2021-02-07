import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:startup/model/model.dart';
import 'package:startup/redux/actions.dart';

class FavoritesPage extends StatefulWidget {
  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (context, viewModel) {
          final Iterable<ListTile> tiles =
              viewModel.startups.map((Startup startup) {
            return ListTile(
              title: Text(startup.name, style: TextStyle(fontSize: 18.0)),
              trailing: MaterialButton(
                  child: Text('remove'),
                  textColor: Colors.red,
                  onPressed: () {
                    viewModel.removeStartup(startup);
                  }),
            );
          });
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            body: ListView(children: divided),
          );
        });
  }
}

class _ViewModel {
  final List<Startup> startups;
  final Function(Startup) removeStartup;

  _ViewModel({this.startups, this.removeStartup});

  factory _ViewModel.create(Store<AppState> store) {
    void _removeStartup(Startup startup) {
      store.dispatch(RemoveStartupAction(startup));
    }

    return _ViewModel(
      startups: store.state.startups,
      removeStartup: _removeStartup,
    );
  }
}
