import 'package:startup/model/model.dart';
import 'package:startup/redux/actions.dart';

import 'package:redux/redux.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    startups: startupReducer(state.startups, action),
    fontSize: fontSizeReducer(state.fontSize, action),
    firebaseState: firebaseReducer(state.firebaseState, action),
  );
}

Reducer<List<Startup>> startupReducer = combineReducers<List<Startup>>([
  TypedReducer<List<Startup>, AddedStartupAction>(addStartupReducer),
  TypedReducer<List<Startup>, RemovedStartupAction>(removeStartupReducer),
  TypedReducer<List<Startup>, RemoveStartupsAction>(removeStartupsReducer),
]);

Reducer<double> fontSizeReducer = combineReducers<double>([
  TypedReducer<double, ChangeFontSizeAction>(changedFontSizeReducer),
]);

Reducer<FirebaseState> firebaseReducer = combineReducers<FirebaseState>([
  TypedReducer<FirebaseState, AddDatabaseReferenceAction>(addDatabaseReferenceReducer),
  TypedReducer<FirebaseState, UserLoadedAction>(userLoadedReducer),
]);

List<Startup> addStartupReducer(List<Startup> startups, AddedStartupAction action) {
  return []
    ..addAll(startups)
    ..add(Startup.fromSnapshot(action.snapshot));
}

List<Startup> removeStartupReducer(List<Startup> startups, RemovedStartupAction action) {
  return List.unmodifiable(List.from(startups)..removeWhere((s) => s.key == action.snapshot.key));
}

double changedFontSizeReducer(double value, ChangeFontSizeAction action) {
  return action.value;
}

FirebaseState addDatabaseReferenceReducer(FirebaseState firebaseState, AddDatabaseReferenceAction action) {
  return firebaseState.copyWith(mainReference: action.databaseReference, subAddStartup: action.subAddStartup, subRemoveStartup: action.subRemoveStartup);
}

FirebaseState userLoadedReducer(FirebaseState firebaseState, UserLoadedAction action) {
  return firebaseState.copyWith(user: action.user);
}

List<Startup> removeStartupsReducer(List<Startup> startups, RemoveStartupsAction action) {
  return List.unmodifiable([]);
}