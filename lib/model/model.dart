import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Startup {
  String key;
  final String name;

  Startup({
    @required this.name,
  });

  Startup.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'];

  Startup._internal(this.key, this.name);

  Startup copyWith({String key, String name}) {
    return Startup._internal(
      key ?? this.key,
      name ?? this.name,
    );
  }

  Map toJson() => {'key': key, 'name': name};

  @override
  String toString() {
    return toJson().toString();
  }
}

class AppState {
  final List<Startup> startups;
  final double fontSize;
  final FirebaseState firebaseState;

  const AppState({
    @required this.startups,
    @required this.fontSize,
    @required this.firebaseState,
  });

  AppState.initialState()
      : startups = List.unmodifiable(<Startup>[]),
        fontSize = 18.0,
        firebaseState = FirebaseState();

  Map toJson() => {'startups': startups, 'numberOfWords': fontSize};

  @override
  String toString() {
    return toJson().toString();
  }
}

class FirebaseState {
  final DatabaseReference mainReference;
  final StreamSubscription<Event> subAddStartup;
  final StreamSubscription<Event> subRemoveStartup;
  final User user;

  const FirebaseState(
      {this.mainReference,
      this.user,
      this.subAddStartup,
      this.subRemoveStartup});

  FirebaseState copyWith(
      {DatabaseReference mainReference,
      User user,
      StreamSubscription<Event> subAddStartup,
      StreamSubscription<Event> subRemoveStartup}) {
    return FirebaseState(
      mainReference: mainReference ?? this.mainReference,
      user: user ?? this.user,
      subAddStartup: subAddStartup ?? this.subAddStartup,
      subRemoveStartup: subRemoveStartup ?? this.subRemoveStartup,
    );
  }
}
