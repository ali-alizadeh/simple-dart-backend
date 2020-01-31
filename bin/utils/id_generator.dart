abstract class IDGenerator {
  static int generate() {
    return DateTime.now().toUtc().microsecondsSinceEpoch;
  }
}
