import '../models.dart';
import 'shows.dart';

abstract class ShowFactory {
  static Show fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'movie') {
      return Movie.fromJson(json);
    }

    return null;
  }

  static List<Person> people(Show show) {
    final res = <Person>[];
    res.addAll(show.producers.map((p) => Person.fromNantionalId(p)).toList());
    if (show is Movie) {
      res.addAll(show.actors.map((p) => Person.fromNantionalId(p)).toList());
      res.addAll(show.stuntMen.map((p) => Person.fromNantionalId(p)).toList());
      res.add(Person.fromNantionalId(show.director));
      res.add(Person.fromNantionalId(show.scriptSupervisor));
    }
    return res;
  }
}
