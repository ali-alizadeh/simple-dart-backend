import 'dart:io';

import 'api.dart';
import 'database.dart';

Future<void> main() async {
  Database();

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Server is running on localhost:${server.port}');
  await for (HttpRequest req in server) {
    await Api.handleRequest(req);
  }
}
