import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String name, String email) async {
    await usersCollection.add({
      'name': name,
      'email': email,
    });
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await usersCollection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
