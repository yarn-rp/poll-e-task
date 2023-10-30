import 'dart:async';

import 'package:api_client/src/collections/collections.dart';
import 'package:api_client/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template platforms_api_client}
/// Client for the platforms API using Firestore.
/// {@endtemplate}
class PlatformsApiClient {
  /// {@macro platforms_api_client}
  PlatformsApiClient({
    required FirebaseFirestore firestore,
  }) : _platformsCollection =
            firestore.collection(Collections.platforms).withConverter(
                  fromFirestore: platformConverter.fromFirestore,
                  toFirestore: platformConverter.toFirestore,
                );

  late final CollectionReference<PlatformModel> _platformsCollection;

  /// Streams all the platforms from Firestore.
  Stream<List<PlatformModel>> getPlatforms() => _platformsCollection
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
}