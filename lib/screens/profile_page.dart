import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:startup/model/model.dart';
import 'package:startup/redux/actions.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel.create(store),
      builder: (context, viewModel) {
        return Scaffold(
            body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: viewModel.user.isAnonymous
                                      ? AssetImage('assets/user.png')
                                      : CachedNetworkImageProvider(viewModel.user.photoURL)))
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16.0),
                          child: viewModel.user.isAnonymous
                              ? Text('Anonymous')
                              : Text(
                                  viewModel.user.displayName,
                                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                                ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    child: viewModel.user.isAnonymous
                    ? Text('login', style: TextStyle(fontSize: 16.0, color: Colors.lightBlue))
                    : Text('logout', style: TextStyle(fontSize: 16.0)),
                    onPressed: () {
                      final isAnonymous = viewModel.user.isAnonymous;
                      if (isAnonymous) {
                        viewModel.login();
                      } else {
                        viewModel.logout();
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(),
            ),
            Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  children: const <Widget>[
                    Text(
                      'Settings',
                      style: TextStyle(fontSize: 18.0),
                    )
                    ],
                )),
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Text('Font size ${viewModel.fontSize.round()}'),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Slider(
                      value: viewModel.fontSize,
                      min: 18,
                      max: 30,
                      divisions: 3,
                      inactiveColor: Colors.black,
                      activeColor: Colors.red,
                      label: '${viewModel.fontSize.round()}',
                      onChanged: (value) {
                        viewModel.changeFontSize(value);
                      },
                    ),
                  ))
                ],
              ),
            )
          ],
        ));
      },
    );
  }
}

class _ViewModel {
  final User user;
  final double fontSize;
  final Function() login;
  final Function() logout;
  final Function(double value) changeFontSize;

  _ViewModel(
      {this.user, this.fontSize, this.login, this.logout, this.changeFontSize});

  factory _ViewModel.create(Store<AppState> store) {
    void _login() {
      store.dispatch(GoogleLoginAction(cachedStartups: store.state.startups));
    }

    void _logout() {
      store.dispatch(GoogleLogoutAction());
    }

    void _changeFontSize(double value) {
      store.dispatch(ChangeFontSizeAction(value));
    }

    return _ViewModel(
        user: store.state.firebaseState.user,
        fontSize: store.state.fontSize,
        login: _login,
        logout: _logout,
        changeFontSize: _changeFontSize);
  }
}
