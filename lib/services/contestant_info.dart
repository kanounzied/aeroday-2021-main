import 'package:cloud_firestore/cloud_firestore.dart';

class ContestantInfo {
  String imageUrl = 'https://picsum.photos/200';
  String name;
  String lastName;
  String teamName;
<<<<<<< HEAD
<<<<<<< HEAD
  //String id;
=======

>>>>>>> a249433e687c237bffc278e19cb2f338b4662511
=======
  //String id;
>>>>>>> 5e3fece (ceci est une situation critique)
  ContestantInfo({
    required this.name,
    required this.lastName,
    required this.teamName,
    required this.imageUrl,
<<<<<<< HEAD
<<<<<<< HEAD
    // this.id,
=======
>>>>>>> a249433e687c237bffc278e19cb2f338b4662511
=======
    // this.id,
>>>>>>> 5e3fece (ceci est une situation critique)
  });

  //returns a ContestantInfo() object filled with data from the map r

  factory ContestantInfo.fromMap(Map r) {
    return new ContestantInfo(
      name: r['name'],
      lastName: r['lastName'],
      imageUrl: r['imageUrl'],
      teamName: r['teamName'],
<<<<<<< HEAD
<<<<<<< HEAD
      //  id: r['id'],
=======
>>>>>>> a249433e687c237bffc278e19cb2f338b4662511
=======
      //  id: r['id'],
>>>>>>> 5e3fece (ceci est une situation critique)
    );
  }
}
