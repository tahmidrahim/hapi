import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    await FirebaseFirestore.instance
        .collection('test')
        .doc('doc1')
        .set({'hello': 'world'});
    print('Firestore connected!');
  } catch (e) {
    print('Firestore error: $e');
  }

  runApp(const ProviderScope(child: KapiApp()));
}
