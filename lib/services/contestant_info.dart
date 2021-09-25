import 'package:cloud_firestore/cloud_firestore.dart';

class ContestantInfo {
  String imageUrl = 'https://picsum.photos/200';
  String name = '';
  String lastName = '';

  String teamName;
  String id;
  String membres;
  String chef;
  String etab;

  int votes;
  ContestantInfo({
    required this.chef,
    required this.etab,
    required this.teamName,
    required this.membres,
    required this.id,
    required this.votes,
  });

  //returns a ContestantInfo() object filled with data from the map r

  factory ContestantInfo.fromMap(Map r, String id) {
    return new ContestantInfo(
      etab: r['etab'],
      chef: r['chef'],
      membres: r['membres'],
      teamName: r['equipe'],
      id: id,
      votes: r['votes'],
    );
  }
}
