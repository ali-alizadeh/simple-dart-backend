import 'dart:convert';
import 'dart:io';

import 'database.dart';
import 'models/models.dart';

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
    if (req.uri.hasQuery) {
      req.response.write('Hiiiiiiiiiiiiii');
      req.response.close();
    } else {
      final file = File(Directory.current.path + '/media' + req.uri.toString());
      if (file.existsSync()) {
        req.response.addStream(file.openRead()).then((_) {
          print(Directory.current.path + '/media' + req.uri.toString());
          req.response.close();
        });
      }
    }
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
          //
        } else if (uri == '/firstBroadcast') {
          //
        }
      } catch (err) {
        req.response.write(jsonEncode({'staus': 0, 'error': err.toString()}));
      }

      req.response.close();
    });
  }

  static void _handleDelete(HttpRequest req) {}

  static void _handlePut(HttpRequest req) {}

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
        jsonEncode({'staus': 0, 'error': 'UserAlreadyExists'}),
      );
    } on NotFoundException {
      Database()
        ..people.insert(person)
        ..updatePeopleDatabase();
      print('New person created');
      req.response.write(jsonEncode({'staus': 1}));
    }
  }

  static void _addShow(HttpRequest req, Map<String, dynamic> json) {
    final show = ShowFactory.fromJson(json);
    final people = ShowFactory.people(show);
    var index = 0;
    try {
      for (index = 0; index < people.length; index++) {
        Database().people.find(people[index]);
      }
      Database().shows.insert(show);
      req.response.write(jsonEncode({'staus': 1}));
    } on NotFoundException {
      req.response.write(jsonEncode({
        'staus': 0,
        'error': 'There\'s no user with id: ${people[index].nationalID}'
      }));
    }
  }
}
