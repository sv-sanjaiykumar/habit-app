import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  String _email = '';
  bool _isLoading = true;

  Map<String, dynamic> _userData = {};
  Map<String, dynamic> get userData => _userData;

  String get name => _name;
  String get email => _email;
  bool get isLoading => _isLoading;

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists) {
          _name = doc['name'] ?? '';
          _email = doc['email'] ?? '';
          _userData = doc.data() ?? {};
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      _userData = doc.data() ?? {};
      notifyListeners();
    }
  }

  void updateUser(String newName, String newEmail) {
    _name = newName;
    _email = newEmail;
    _userData['name'] = newName;
    _userData['email'] = newEmail;
    notifyListeners();
  }
}
