import 'package:poll_e_task/integrations/entities/integration.dart';
import 'package:poll_e_task/tasks/entities/entities.dart';

/// {@template project}
/// A project that can be defined in a platform.
/// {@endtemplate}
class Project {
  /// Creates a new [Project] instance with the provided properties.
  const Project({
    required this.id,
    required this.platformId,
    required this.platformURL,
    required this.integration,
    required this.name,
    required this.description,
    required this.members,
    required this.colorHex,
    this.iconUrl,
  });

  /// Kick-off identifier for the project.
  final String id;

  /// Platform-specific identifier for the project.
  final String platformId;

  /// Platform-specific URL for the project (ex: Jira URL).
  final Uri platformURL;

  /// The integration way of the project.
  final Integration integration;

  /// The name of the project.
  final String name;

  /// A brief description of the project.
  final String description;

  /// URL of the project icon, if available.
  final String? iconUrl;

  /// An array of users who are members of the project.
  final List<User> members;

  /// The color of the project.
  final String colorHex;
}
