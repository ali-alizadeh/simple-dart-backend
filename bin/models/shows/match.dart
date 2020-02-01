import 'package:meta/meta.dart';

import '../models.dart';

class Match extends Show {
  final int scriptSupervisor;
  List<int> hosts;
  List<int> matchParticipants;

  Match({
    @required int id,
    @required String name,
    @required DateTime productionDate,
    @required List<BroadcastInfo> broadcastInfo,
    @required List<int> producers,
    @required int director,
    @required this.scriptSupervisor,
    @required this.hosts,
    @required this.matchParticipants,
  }) : super(
          id: id,
          name: name,
          productionDate: productionDate,
          broadcastInfo: broadcastInfo,
          producers: producers,
          director: director,
        );

  Match.fromJson(Map<String, dynamic> json)
      : scriptSupervisor = json['scriptSupervisor'],
        hosts = json['hosts'].cast<int>(),
        matchParticipants = json['matchParticipants'].cast<int>(),
        super.fromJson(json);

  Match.fromId(int id)
      : this(
          id: id,
          name: null,
          productionDate: null,
          broadcastInfo: null,
          producers: null,
          director: null,
          scriptSupervisor: null,
          hosts: null,
          matchParticipants: null,
        );

  @override
  Match copyWith({
    int id,
    String name,
    DateTime productionDate,
    List<BroadcastInfo> broadcastInfo,
    List<int> producers,
    int director,
    int scriptSupervisor,
    List<int> hosts,
    List<int> matchParticipants,
  }) {
    return Match(
      id: id ?? this.id,
      name: name ?? this.name,
      productionDate: productionDate ?? this.productionDate,
      broadcastInfo: broadcastInfo ?? this.broadcastInfo,
      producers: producers ?? this.producers,
      director: director ?? this.director,
      scriptSupervisor: scriptSupervisor ?? this.scriptSupervisor,
      hosts: hosts ?? this.hosts,
      matchParticipants: matchParticipants ?? this.matchParticipants,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'scriptSupervisor': scriptSupervisor,
        'hosts': hosts,
        'matchParticipants': matchParticipants,
      });
  }
}
