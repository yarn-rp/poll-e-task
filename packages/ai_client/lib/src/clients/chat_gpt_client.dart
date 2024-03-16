import 'dart:convert';

import 'package:ai_client/src/ai_client.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:rxdart/rxdart.dart';

const _userRole = 'user';
const _assistantRole = 'assistant';

/// {@template chat_gpt_ai_client}
/// A client to interact with the ChatGPT AI model.
/// {@endtemplate}
class ChatGPTAiClient implements AiClient {
  /// {@macro chat_gpt_ai_client}
  ChatGPTAiClient({
    required String apiKey,
  }) {
    _threadId = BehaviorSubject<String?>();

    _openAI = OpenAI.instance.build(
      token: apiKey,
    );
  }

  late final OpenAI _openAI;

  /// The model to use for the AI.
  String get _assistantId => 'asst_CEoNM7TIgsMvx2WsrlAfZjwD';

  /// The current created thread for this session. If null, means that the
  /// thread has not been created yet.
  late final BehaviorSubject<String?> _threadId;

  /// Creates a thread for the session.
  Future<void> startChat() async {
    final thread = await _openAI.threads.createThread(
      request: ThreadRequest(messages: []),
    );

    // Change the value of the behavior subject to the new thread id.
    _threadId.add(thread.id);
  }

  /// Adds a message to the current thread.
  Future<void> addMessageToThread({
    required String content,
    required String role,
  }) async {
    if (_threadId.value == null) {
      // If the thread has not been created yet, create it.
      await startChat();
    }

    await _openAI.threads.messages.createMessage(
      threadId: _threadId.value!,
      request: CreateMessage(
        role: role,
        content: content,
      ),
    );
  }

  Future<String> _getLastMessage() async {
    final messages = await _openAI.threads.messages.listMessage(
      threadId: _threadId.value!,
    );

    return messages.data.last.content.fold(
      '',
      (previousValue, element) => '$previousValue\n ${element.text!.value}',
    );
  }

  /// Prompt the AI with a message and receive a response.
  @override
  Future<String> generateContentString({
    required String content,
    Map<String, dynamic>? metadata,
  }) async {
    if (_threadId.value == null) {
      // If the thread has not been created yet, create it.
      await startChat();
    }

    final request = CreateRun(assistantId: _assistantId);
    final metadataSerialized = jsonEncode(metadata);

    await addMessageToThread(
      content: '$content\n$metadataSerialized',
      role: _userRole,
    );

    final createRun = await _openAI.threads.runs.createRun(
      threadId: _threadId.value!,
      request: request,
    );

    final runId = createRun.id;
    while (true) {
      final run = await _openAI.threads.runs.retrieveRun(
        threadId: _threadId.value!,
        runId: runId,
      );

      await Future<void>.delayed(const Duration(seconds: 1));

      if (run.status == 'completed') {
        final response = await _getLastMessage();
        return response;
      }
    }
  }
}
