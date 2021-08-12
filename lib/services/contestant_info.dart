class ContestantInfo {
  String imageUrl = 'https://picsum.photos/200';
  String name;
  String lastName;
  int status;
  int votes;

  ContestantInfo({
    required this.name,
    required this.lastName,
    required this.imageUrl,
    required this.status,
    required this.votes,
  });
  //returns a ContestantInfo() object filled with data from the map r
  factory ContestantInfo.fromMap(Map r) {
    return new ContestantInfo(
      name: r['name'],
      lastName: r['lastName'],
      imageUrl: r['imageUrl'],
      status: r['status'],
      votes: r['votes'],
    );
  }
}
