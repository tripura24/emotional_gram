import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> registerNewUser(String userId, {int credits = 3}) async {
    try {
      await _usersCollection.doc(userId).set({'credits': credits});
    } catch (e) {
      print('Error registering new user: $e');
    }
  }

  Future<int> getUserCredits(String userId) async {
    try {
      final userDocSnapshot = await _usersCollection.doc(userId).get();
      if (userDocSnapshot.exists) {
        final userData = userDocSnapshot.data() as Map<String, dynamic>;
        return userData['credits'] ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error fetching user credits: $e');
      return 0;
    }
  }

  Future<void> updateCredits(String userId, int newCredits) async {
    try {
      await _usersCollection.doc(userId).update({'credits': newCredits});
    } catch (e) {
      print('Error updating user credits: $e');
    }
  }
}
