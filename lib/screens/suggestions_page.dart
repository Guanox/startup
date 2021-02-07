import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:startup/model/model.dart';
import 'package:startup/redux/actions.dart';

class SuggestionsPage extends StatefulWidget {

  @override
  SuggestionsPageState createState() => SuggestionsPageState();
}

class SuggestionsPageState extends State<SuggestionsPage> {
  final List<WordPair> _suggestions = <WordPair>[];

  SuggestionsPageState();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (context, viewModel) {
          return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (BuildContext _context, int i) {
                if (i.isOdd) {
                  return Divider();
                }

                final int index = i ~/ 2;
                if (index >= _suggestions.length) {
                  _suggestions.addAll(generateWordPairs().take(10));
                }
                return _buildRow(_suggestions[index], viewModel);
              });
        });
  }

  Widget _buildRow(WordPair pair, _ViewModel viewModel) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: TextStyle(fontSize: viewModel.fontSize),
      ),
      onTap: () {
        _suggestions.remove(pair);
        viewModel.onAddStartup(pair.asPascalCase);
      },
    );
  }
}

class _ViewModel {
  final double fontSize;
  final List<Startup> startups;
  final Function(String) onAddStartup;

  _ViewModel({this.fontSize, this.startups, this.onAddStartup});

  factory _ViewModel.create(Store<AppState> store) {
    void _onAddStartup(String name) {
      store.dispatch(AddStartupAction(Startup(name: name)));
    }

    return _ViewModel(
      fontSize: store.state.fontSize,
      startups: store.state.startups,
      onAddStartup: _onAddStartup,
    );
  }
}
