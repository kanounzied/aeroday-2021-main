import 'package:cloud_firestore/cloud_firestore.dart';

class ContestantInfo {
  String imageUrl = 'https://picsum.photos/200';
  String name;
  String lastName;
  String teamName;
  String id;
  int votes;
  ContestantInfo({
    required this.name,
    required this.lastName,
    required this.teamName,
    required this.imageUrl,
    required this.id,
    required this.votes,
  });

  //returns a ContestantInfo() object filled with data from the map r

  factory ContestantInfo.fromMap(Map r, String id) {
    return new ContestantInfo(
      name: r['name'],
      lastName: r['lastName'],
      imageUrl: r['imageUrl'],
      teamName: r['teamName'],
      id: id,
      votes: r['votes'],
    );
  }
}
