import 'package:meta/meta.dart';

import 'channel.dart';
import 'exceptions.dart';

class BroadcastInfo {
  final DateTime broadcastDate;
  final String channel;

  const BroadcastInfo._({
    @required this.broadcastDate,
    @required this.channel,
  });

  /// If the given channel is invalid it throws: `InvaildChannelException`
  ///
  /// If the given date is invalid it throws: `FormatException`
  factory BroadcastInfo({
    @required DateTime broadcastDate,
    @required String channel,
  }) {
    if (Channel.exists(channel) == false) {
      throw const InvaildChannelException();
    }
    return BroadcastInfo._(
      broadcastDate: broadcastDate,
      channel: channel,
    );
  }

  /// If the given channel is invalid it throws: `InvaildChannelException`
  ///
  /// If the given date is invalid it throws: `FormatException`
  factory BroadcastInfo.fromJson(Map<String, dynamic> json) {
    return BroadcastInfo(
      broadcastDate: DateTime.parse(json['broadcastDate']),
      channel: json['channel'],
    );
  }

  Map<String, dynamic> toJson() => {
        'broadcastDate': broadcastDate.toIso8601String(),
        'channel': channel,
      };
}
