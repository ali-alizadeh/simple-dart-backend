import 'dart:convert';
import 'dart:io';

import 'models/models.dart';

class Database {
  static Database _instance;
  static const _DB_DIR_PATH = 'db';
  static const _SHOWS_DB_PATH = 'shows.json';
  static const _PEOPLE_DB_PATH = 'people.json';

  static File get _SHOWS_DB => File('$_DB_DIR_PATH/$_SHOWS_DB_PATH');
  static File get _PEOPLE_DB => File('$_DB_DIR_PATH/$_PEOPLE_DB_PATH');
  static Directory get _DB_DIR => Directory(_DB_DIR_PATH);

  final shows = AvlTree<Show>();
  final people = AvlTree<Person>();

  factory Database() => _instance ?? (_instance = Database._());

  Database._() {
    _createDataBase();
    _loadDataBase();
  }

  void _createDataBase() {
    if (_DB_DIR.existsSync() == false) {
      _DB_DIR.createSync();
    }

    if (_SHOWS_DB.existsSync() == false) {
      _SHOWS_DB
        ..createSync()
        ..writeAsStringSync(jsonEncode({'shows': []}));
    }

    if (_PEOPLE_DB.existsSync() == false) {
      _PEOPLE_DB
        ..createSync()
        ..writeAsStringSync(jsonEncode({'people': []}));
    }
  }

  void _loadDataBase() {
    final List<Map<String, dynamic>> shows =
        jsonDecode(_SHOWS_DB.readAsStringSync())['shows']
            .cast<Map<String, dynamic>>();
    final List<Map<String, dynamic>> people =
        jsonDecode(_PEOPLE_DB.readAsStringSync())['people']
            .cast<Map<String, dynamic>>();

    for (Map show in shows) {
      this.shows.insert(ShowFactory.fromJson(show));
    }

    for (Map person in people) {
      this.people.insert(Person.fromJson(person));
    }
  }

  void updateShowsDatabase() {
    final shows = <Show>[];
    this.shows.preOrder(shows.add);
    final showsJson = shows.map((Show show) => show.toJson()).toList();
    _SHOWS_DB.writeAsStringSync(jsonEncode({'shows': showsJson}));
  }

  void updatePeopleDatabase() {
    final people = <Person>[];
    this.people.preOrder(people.add);
    final peopleJson = people.map((Person person) => person.toJson()).toList();
    _PEOPLE_DB.writeAsStringSync(jsonEncode({'people': peopleJson}));
  }
}
