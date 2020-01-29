import 'package:meta/meta.dart';

import '../broadcast_info.dart';

abstract class Show {
  final int id;
  final String name;
  final DateTime productionDate;
  final List<BroadcastInfo> broadcastInfo;
  final List<int> producers;

  DateTime get firstBroadcastDate {
    if (broadcastInfo.isEmpty) return null;
    return broadcastInfo[0].broadcastDate;
  }

  /// count of broadcasts of the show across different channels
  int get broadcastsCount => broadcastInfo?.length ?? 0;
  String get type => runtimeType.toString().toLowerCase();

  Show({
    @required this.id,
    @required this.name,
    @required this.productionDate,
    @required this.broadcastInfo,
    @required this.producers,
  });

  Show.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        productionDate = DateTime.parse(json['productionDate']),
        broadcastInfo = (json['broadcastInfo'] as List)
            .map((info) => BroadcastInfo.fromJson(info))
            .toList(),
        producers = json['producers'].cast<int>();

  Show copyWith({
    int id,
    String name,
    DateTime productionDate,
    List<BroadcastInfo> broadcastInfo,
    List<int> producers,
  });

  bool operator >(Show other) => id > other.id;

  bool operator <(Show other) => id < other.id;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'productionDate': productionDate.toIso8601String(),
        'broadcastInfo': broadcastInfo.map((info) => info.toJson).toList(),
        'producers': producers,
        'type': type,
      };
}
