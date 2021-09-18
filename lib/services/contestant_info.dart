import 'package:cloud_firestore/cloud_firestore.dart';

class ContestantInfo {
  String imageUrl = 'https://picsum.photos/200';
  String name;
  String lastName;
  String teamName;
<<<<<<< HEAD
  //String id;
=======

>>>>>>> a249433e687c237bffc278e19cb2f338b4662511
  ContestantInfo({
    required this.name,
    required this.lastName,
    required this.teamName,
    required this.imageUrl,
<<<<<<< HEAD
    // this.id,
=======
>>>>>>> a249433e687c237bffc278e19cb2f338b4662511
  });

  //returns a ContestantInfo() object filled with data from the map r

  factory ContestantInfo.fromMap(Map r) {
    return new ContestantInfo(
      name: r['name'],
      lastName: r['lastName'],
      imageUrl: r['imageUrl'],
      teamName: r['teamName'],
<<<<<<< HEAD
      //  id: r['id'],
=======
>>>>>>> a249433e687c237bffc278e19cb2f338b4662511
    );
  }
}
