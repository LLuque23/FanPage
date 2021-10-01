import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection references

  final String uid;
  DatabaseService({this.uid = ''});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');
  final orderedPostCollection = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('creation_date', descending: true);

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Stream<QuerySnapshot> get posts {
    return orderedPostCollection.snapshots();
  }

  Stream<DocumentSnapshot> get user {
    return userCollection.doc(uid).snapshots();
  }

  addPost(String title, String body) {
    postCollection
        .add({'title': title, 'body': body, 'creation_date': DateTime.now()});
  }
}
