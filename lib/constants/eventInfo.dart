class EventStats {
  /* 
  Values:
    Airshow
    Videographie par drone
  */
  static String currentEvent = '';

  /// 0 --> Airshow
  /// 1 --> Vpd
  static const List<String> EventList = [
    'Airshow',
    'Videographie par drone'
  ]; // Linked to DB! Don't change

  /*
  Values:
    vote
    leaderboard
    locked
    wait
  */
  static String airshowStats = '';
  static String vpdStats = '';
}
