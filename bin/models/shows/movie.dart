import 'package:meta/meta.dart';

import '../models.dart';

class Movie extends Show {
  final int scriptSupervisor;
  final List<int> actors;
  final List<int> stuntMen;

  Movie({
    @required int id,
    @required String name,
    @required DateTime productionDate,
    @required List<BroadcastInfo> broadcastInfo,
    @required List<int> producers,
    @required int director,
    @required this.scriptSupervisor,
    @required this.actors,
    this.stuntMen,
  }) : super(
            id: id,
            name: name,
            productionDate: productionDate,
            broadcastInfo: broadcastInfo,
            producers: producers,
            director: director);

  Movie.fromJson(Map<String, dynamic> json)
      : scriptSupervisor = json['scriptSupervisor'],
        actors = json['actors'].cast<int>(),
        stuntMen = json['stuntMen'].cast<int>(),
        super.fromJson(json);

  Movie.fromId(int id)
      : this(
          id: id,
          name: null,
          productionDate: null,
          broadcastInfo: null,
          producers: null,
          director: null,
          scriptSupervisor: null,
          actors: null,
          stuntMen: null,
        );

  @override
  Movie copyWith({
    int id,
    String name,
    DateTime productionDate,
    List<BroadcastInfo> broadcastInfo,
    List<int> producers,
    int director,
    int scriptSupervisor,
    List<int> actors,
    List<int> stuntMen,
  }) {
    return Movie(
      id: id ?? this.id,
      name: name ?? this.name,
      productionDate: productionDate ?? this.productionDate,
      broadcastInfo: broadcastInfo ?? this.broadcastInfo,
      producers: producers ?? this.producers,
      director: director ?? this.director,
      scriptSupervisor: scriptSupervisor ?? this.scriptSupervisor,
      actors: actors ?? this.actors,
      stuntMen: stuntMen ?? this.stuntMen,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'scriptSupervisor': scriptSupervisor,
        'actors': actors,
        'stuntMen': stuntMen,
      });
  }
}

// void main(List<String> args) {
//   final a = Movie.fromJson({
//     'id': 0,
//     'name': 'name',
//     'productionDate': '2020-01-29T14:36:26.494520',
//     'firstBroadcastDate': '2020-01-29T14:36:26.494520',
//     'broadcastInfo': [],
//     'producers': [1, 2, 3],
//     'type': 'movie',
//     'director': 1,
//     'scriptSupervisor': 1,
//     'actors': [1, 5, 9, 8],
//     'stuntMen': [2]
//   });

//   print(jsonEncode(a.toJson()).replaceAll('"', '\''));
// }
