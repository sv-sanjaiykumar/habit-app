import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryItem {
  final String habitName;
  final DateTime completedOn;

  HistoryItem({required this.habitName, required this.completedOn});

  factory HistoryItem.fromMap(Map<String, dynamic> data) {
    return HistoryItem(
      habitName: data['habitName'] ?? '',
      completedOn: (data['completedOn'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habitName': habitName,
      'completedOn': completedOn,
    };
  }
}

class HistoryProvider with ChangeNotifier {
  final List<HistoryItem> _history = [];

  List<HistoryItem> get history => _history.reversed.toList();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addToHistory(String habitName) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newItem = HistoryItem(
      habitName: habitName,
      completedOn: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .add(newItem.toMap());

    _history.add(newItem);
    notifyListeners();
  }

  Future<void> clearUserHistory(String userEmail) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final batch = _firestore.batch();
    final historyCollection = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .get();

    final deletedHistoryCollection = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('deleted_history');

    for (final doc in historyCollection.docs) {
      // Archive the deleted item
      batch.set(deletedHistoryCollection.doc(), doc.data());
      // Then delete the original
      batch.delete(doc.reference);
    }

    await batch.commit();
    _history.clear();
    notifyListeners();
  }


  Future<void> loadUserHistory(String userEmail) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .orderBy('completedOn', descending: true)
          .get();

      _history.clear();
      _history.addAll(snapshot.docs
          .map((doc) => HistoryItem.fromMap(doc.data()))
          .toList());

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }
}
