import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------- AUTH ----------------

  Future<User?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return cred.user;
    } catch (e) {
      throw Exception('Sign-in failed: ${e.toString()}');
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestore.collection('users').doc(cred.user!.uid).set({
        'email': email,
        'name': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return cred.user;
    } catch (e) {
      throw Exception('Sign-up failed: ${e.toString()}');
    }
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ---------------- HABITS ----------------

  Future<void> addHabit(
      String title,
      String description, [
        DateTime? deadline,
      ]) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    final Map<String, dynamic> habitData = {
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'isCompleted': false,
    };

    if (deadline != null) {
      habitData['deadline'] = deadline;
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .add(habitData);
  }

  Future<List<Map<String, dynamic>>> fetchUserHabits() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    final habitsSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .orderBy('createdAt', descending: true)
        .get();

    return habitsSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['title'] ?? '',
        'description': data['description'] ?? '',
        'deadline': data['deadline'],
        'createdAt': data['createdAt'],
        'isCompleted': data['isCompleted'] ?? false,
      };
    }).toList();
  }

  Future<void> updateHabitStatus(String habitId, bool newStatus) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .doc(habitId)
        .update({'isCompleted': newStatus});
  }

  Future<void> deleteHabit(String habitId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .doc(habitId)
        .delete();
  }
}
