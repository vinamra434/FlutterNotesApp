import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_http_app/data/repository/note_repository.dart';
import 'home/note_list.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => NoteRepository());
}

void main() {
  setupLocator();
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      home: NoteList(),
    );
  }
}
