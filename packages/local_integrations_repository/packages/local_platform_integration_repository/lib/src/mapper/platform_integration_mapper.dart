import 'package:local_platform_integration_repository/src/entities/entities.dart';

/// {@template platform_integration_mapper}
/// Class in charge of mapping the [Integration] class to a json and viceversa.
/// To implement a new mapper, you must extend this class and implement the
/// abstract methods.
/// {@endtemplate}
abstract interface class PlatformIntegrationMapper<
    PlatformType extends Platform,
    IntegrationType extends Integration<PlatformType>> {
  /// Maps a [json] to an [IntegrationType].
  IntegrationType fromJson(Map<String, dynamic> json);

  /// Maps an [IntegrationType] to a Map<String,dynamic>.
  Map<String, dynamic> toJson(IntegrationType integration);
}