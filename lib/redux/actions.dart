import 'dart:async';
import 'package:startup/model/model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLoadedAction {
  final User user;

  UserLoadedAction(this.user);
}

class GoogleLoginAction {
  final List<Startup> cachedStartups;

  GoogleLoginAction({this.cachedStartups = const []});
}

class GoogleLogoutAction {}

class RemoveStartupsAction {}

class AddStartupAction {
  final Startup startup;

  AddStartupAction(this.startup);
}

class AddedStartupAction {
  final DataSnapshot snapshot;

  AddedStartupAction(this.snapshot);
}

class RemoveStartupAction {
  final Startup startup;

  RemoveStartupAction(this.startup);
}

class RemovedStartupAction {
  final DataSnapshot snapshot;

  RemovedStartupAction(this.snapshot);
}

class ChangeFontSizeAction {
  final double value;

  ChangeFontSizeAction(this.value);
}

class InitAction { }

class AddDatabaseReferenceAction {
  final DatabaseReference databaseReference;
  final StreamSubscription<Event> subAddStartup;
  final StreamSubscription<Event> subRemoveStartup;

  AddDatabaseReferenceAction(this.databaseReference, this.subAddStartup, this.subRemoveStartup);
}