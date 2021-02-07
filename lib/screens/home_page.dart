import 'package:flutter/material.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux/redux.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';

import 'package:startup/model/model.dart';
import 'package:startup/redux/actions.dart';

import 'favorites_page.dart';
import 'profile_page.dart';
import 'suggestions_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _widgetTabs = [
    SuggestionsPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (context, viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Startup Name Generator'),
            ),
            body: _widgetTabs.elementAt(_selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Suggestions'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'Favorites'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: 'Account')
              ],
              fixedColor: Colors.lightBlue,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
            drawer: Container(
              child: ReduxDevTools(viewModel.store),
            ),
          );
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _ViewModel {
  final DevToolsStore<AppState> store;
  final User user;
  final Function() login;
  final Function() logout;

  _ViewModel({this.store, this.user, this.login, this.logout});

  factory _ViewModel.create(Store<AppState> store) {
    void _login() {
      store.dispatch(GoogleLoginAction(cachedStartups: store.state.startups));
    }

    void _logout() {
      store.dispatch(GoogleLogoutAction());
    }

    return _ViewModel(
        store: store,
        user: store.state.firebaseState.user,
        login: _login,
        logout: _logout);
  }
}
