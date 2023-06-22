int get daysSince1970InBJTime {
  return ((DateTime.now().toUtc().millisecondsSinceEpoch + 60 * 60 * 1000 * 8) /
          (24 * 60 * 60 * 1000))
      .floor()
      .toInt();
}
