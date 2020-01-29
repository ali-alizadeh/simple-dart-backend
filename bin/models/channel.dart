abstract class Channel {
  static const one = 'one';
  static const two = 'two';
  static const three = 'three';
  static const four = 'four';
  static const five = 'five';
  static const news = 'news';
  static const education = 'education';
  static const quran = 'quran';
  static const documentry = 'documentry';
  static const nasim = 'nasim';
  static const shoma = 'shoma';
  static const namayesh = 'namayesh';
  static const sports = 'sports';
  static const children = 'children';
  static const health = 'health';
  static const tamasha = 'tamasha';
  static const ofogh = 'ofogh';
  static const omid = 'omid';
  static const iranKala = 'iranKala';
  static const iFilm = 'iFilm';
  static const pressTV = 'pressTV';
  static const alAlam = 'alAlam';
  static const alKousar = 'alKousar';

  static List<String> get _channels => [
        one,
        two,
        three,
        four,
        five,
        news,
        education,
        quran,
        documentry,
        nasim,
        shoma,
        namayesh,
        sports,
        children,
        health,
        tamasha,
        ofogh,
        omid,
        iranKala,
        iFilm,
        pressTV,
        alAlam,
        alKousar,
      ];

  static bool exists(String channel) => _channels.contains(channel);
}
