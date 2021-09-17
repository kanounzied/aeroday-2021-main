import 'package:cloud_firestore/cloud_firestore.dart';

class ContestantInfo {
  String imageUrl = 'https://picsum.photos/200';
  String name;
  String lastName;
  String teamName;

  ContestantInfo({
    required this.name,
    required this.lastName,
    required this.teamName,
    required this.imageUrl,
  });

  //returns a ContestantInfo() object filled with data from the map r

  factory ContestantInfo.fromMap(Map r) {
    return new ContestantInfo(
      name: r['name'],
      lastName: r['lastName'],
      imageUrl: r['imageUrl'],
      teamName: r['teamName'],
    );
  }
}
