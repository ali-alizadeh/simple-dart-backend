import 'dart:convert';
import 'dart:io';

import 'database.dart';
import 'models/models.dart';
import 'utils/id_generator.dart';

abstract class Api {
  static void handleRequest(HttpRequest req) {
    req.response.headers.contentType = ContentType(
      'Content-Type',
      'application/json',
    );
    if (req.method == 'GET') {
      _handleGet(req);
    } else if (req.method == 'POST') {
      _handlePost(req);
    } else if (req.method == 'DELETE') {
      _handleDelete(req);
    } else if (req.method == 'PUT') {
      _handlePut(req);
    }
  }

  static void _handleGet(HttpRequest req) {
    try {
      if (req.uri.path == '/show') {
        _getShowById(req);
      } else if (req.uri.path == '/shows') {
        _getAllShows(req);
      }
    } catch (err) {
      req.response.write(jsonEncode({'status': 0, 'error': err.toString()}));
    }

    req.response.close();
  }

  static void _handlePost(HttpRequest req) {
    utf8.decoder.bind(req).join().then((value) {
      try {
        final body = jsonDecode(value);
        final uri = req.uri.toString();

        if (uri == '/person') {
          _addPerson(req, body);
        }
        if (uri == '/show') {
          _addShow(req, body);
        } else if (uri == '/newBroadcast') {
          _setBroadcast(req, body);
        } else if (uri == '/firstBroadcast') {
          _setBroadcast(req, body, first: true);
        }
      } catch (err) {
        print(err);
        req.response.write(jsonEncode({'status': 0, 'error': err.toString()}));
      }

      req.response.close();
    });
  }

  static void _handleDelete(HttpRequest req) {
    try {
      if (req.uri.path == '/show') {
        _deleteShow(req);
      }
    } catch (err) {
      req.response.write(jsonEncode({'status': 0, 'error': err.toString()}));
    }
    req.response.close();
  }

  static void _handlePut(HttpRequest req) {
    utf8.decoder.bind(req).join().then((value) {
      try {
        final body = jsonDecode(value);
        final uri = req.uri.path;

        if (uri == '/show') {
          _editShow(req, body);
        }
      } catch (err) {
        req.response.write(jsonEncode({'status': 0, 'error': err.toString()}));
      }

      req.response.close();
    });
  }

  //

  static void _addPerson(HttpRequest req, Map<String, dynamic> body) {
    final person = Person(
      name: body['name'],
      birthday: DateTime.parse(body['birthday']),
      phone: body['phone'],
      nationalID: body['nationalID'],
    );

    try {
      Database().people.find(person);
      req.response.write(
        jsonEncode({'status': 0, 'error': 'UserAlreadyExists'}),
      );
    } on NotFoundException {
      Database()
        ..people.insert(person)
        ..updatePeopleDatabase();
      print('New person created');
      req.response.write(jsonEncode({'status': 1}));
    }
  }

  static void _addShow(HttpRequest req, Map<String, dynamic> json) {
    final showJson = json;
    final id = IDGenerator.generate();
    showJson.addAll({'id': id});
    final show = ShowFactory.fromJson(showJson);
    final people = ShowFactory.people(show);
    var index = 0;
    try {
      for (index = 0; index < people.length; index++) {
        Database().people.find(people[index]);
      }
      Database()
        ..shows.insert(show)
        ..updateShowsDatabase();
      req.response.write(jsonEncode({'status': 1, 'id': id}));
    } on NotFoundException {
      req.response.write(jsonEncode({
        'staus': 0,
        'error': 'There\'s no user with id: ${people[index].nationalID}'
      }));
    }
  }

  static void _deleteShow(HttpRequest req) {
    try {
      final key = Movie.fromId(int.parse(req.uri.queryParameters['id']));
      Database()
        ..shows.find(key)
        ..shows.delete(key)
        ..updateShowsDatabase();

      req.response.write(jsonEncode({'status': 1}));
    } on NotFoundException {
      req.response.write(
        jsonEncode({'status': 0, 'error': 'There\'s no show with such id.'}),
      );
    }
  }

  static void _editShow(HttpRequest req, body) {
    try {
      final key = Movie.fromId(body['id']);
      final newShow = ShowFactory.fromJson(body);

      Database()
        ..shows.edit(key, newShow)
        ..updateShowsDatabase();

      req.response.write(jsonEncode({'status': 1}));
    } on NotFoundException {
      req.response.write(
        jsonEncode({'status': 0, 'error': 'There\'s no show with such id.'}),
      );
    }
  }

  static void _getShowById(HttpRequest req) {
    try {
      final key = Movie.fromId(int.parse(req.uri.queryParameters['id']));
      final res = Database().shows.find(key);
      req.response.write(jsonEncode({'status': 1, 'show': res}));
    } on NotFoundException {
      req.response.write(
        jsonEncode({'status': 0, 'error': 'There\'s no show with such id.'}),
      );
    }
  }

  static void _setBroadcast(
    HttpRequest req,
    Map<String, dynamic> body, {
    bool first = false,
  }) {
    try {
      final key = Movie.fromId(body['id']);
      final show = Database().shows.find(key);
      if (show.broadcastInfo.isNotEmpty && first) {
        throw 'First broadcast date is already set.';
      }
      if (show.broadcastInfo.isEmpty && first == false) {
        throw 'First broadcast date is not set yet.';
      }
      show.broadcastInfo.add(BroadcastInfo.fromJson(body['broadcastInfo']));
      Database().updateShowsDatabase();
      req.response.write(jsonEncode({'status': 1}));
    } on InvaildChannelException {
      req.response.write(
        jsonEncode({'status': 0, 'error': 'Enter a valid channel.'}),
      );
    } on NotFoundException {
      req.response.write(
        jsonEncode({'status': 0, 'error': 'There\'s no show with such id.'}),
      );
    }
  }

  static void _getAllShows(HttpRequest req) {
    final sort = req.uri.queryParameters['sort'];
    final shows = <Show>[];
    Database().shows.inOrder(shows.add);

    if (sort == 'id') {
      req.response.write(jsonEncode({'status': 1, 'shows': shows}));
    } else if (sort == 'broadcastDate') {
      final date = DateTime.parse(req.uri.queryParameters['broadcastDate']);
      req.response.write(
        jsonEncode({
          'status': 1,
          'shows': shows.where((show) {
            return show.broadcastInfo
                    .indexWhere((info) => info.broadcastDate == date) !=
                -1;
          }).toList(),
        }),
      );
    } else if (sort == 'channel') {
      final channel = req.uri.queryParameters['channel'];
      req.response.write(
        jsonEncode({
          'status': 1,
          'shows': shows.where((show) {
            return show.broadcastInfo
                    .indexWhere((info) => info.channel == channel) !=
                -1;
          }).toList(),
        }),
      );
    } else if (sort == 'director') {
      final directorId = int.parse(req.uri.queryParameters['directorId']);
      req.response.write(
        jsonEncode({
          'status': 1,
          'shows': shows.where((show) => show.director == directorId).toList(),
        }),
      );
    } else if (sort == 'repeatTimes') {
      final repeatTimes = int.parse(req.uri.queryParameters['repeatTimes']);
      req.response.write(
        jsonEncode({
          'status': 1,
          'shows': shows
              .where((show) => show.broadcastsCount >= repeatTimes)
              .toList(),
        }),
      );
    }
  }
}
