import 'dart:io';

import 'database.dart';

Future<void> main() async {
  Database();
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Server is running on localhost:${server.port}');
  await for (HttpRequest req in server) {
    await handleRequest(req);
  }
}

void handleRequest(HttpRequest req) {
  if (req.method == 'GET') {
    handleGet(req);
  } else {
    handlePost(req);
  }
}

void handleGet(HttpRequest req) {
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

void handlePost(HttpRequest req) {
  //
}

// TODO: serach more to see if it is needed
String join(String part1, String part2) {
  var res = part1 + part2;
  if (Platform.isWindows) {
    return res.replaceAll('/', '\\');
  } else {
    return res.replaceAll('\\', '/');
  }
}
