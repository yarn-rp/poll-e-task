// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:jira_repository/src/entities/jira_platform.dart';
import 'package:platform_integration_repository/platform_integration_repository.dart';

/// An integration with Jira (https://www.atlassian.com/software/jira).
/// software.
class JiraIntegration extends Integration {
  /// Creates a new [JiraIntegration] instance with the provided properties.
  const JiraIntegration({
    required this.url,
    required this.user,
  }) : super(jiraPlatform);

  /// The url of the Jira instance.
  final String url;

  /// The user of the Jira instance.
  final String user;

  @override
  List<Object?> get props => [url, user];
}