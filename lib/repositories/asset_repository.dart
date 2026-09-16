import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/asset_model.dart';

class AssetRepository extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  AssetRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<AssetModel>> getAssetsStream() {
    return _firestore.collection('Assets').snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return AssetModel.fromMap(
              doc.data(),
              doc.id,
            );
          },
        ).toList();
      },
    );
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final document = await _firestore.collection('users').doc(uid).get();

    return document.data();
  }
}
