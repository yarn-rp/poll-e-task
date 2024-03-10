import 'package:bloc/bloc.dart';
import 'package:blueprint_repository/blueprint_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:task_repository/task_repository.dart';
import 'package:uuid/uuid.dart';

part 'ai_assistant_chat_event.dart';
part 'ai_assistant_chat_state.dart';

const _user = types.User(
  id: 'current-user',
  firstName: 'you',
  role: types.Role.user,
);

const _bot = types.User(
  id: 'bot',
  firstName: 'AI Assistant',
  role: types.Role.agent,
);

class AiAssistantChatBloc
    extends Bloc<AiAssistantChatEvent, AiAssistantChatState> {
  AiAssistantChatBloc({
    required Uuid uuid,
    required BlueprintRepository blueprintRepository,
    required TaskRepository taskRepository,
    types.User bot = _bot,
    types.User me = _user,
    List<String> initialBotMessages = const [],
  })  : _uuid = uuid,
        _blueprintRepository = blueprintRepository,
        _taskRepository = taskRepository,
        _tasks = [],
        super(
          AiAssistantChatState(
            messages: initialBotMessages
                .map(
                  (e) => types.TextMessage(
                    author: bot,
                    id: uuid.v4(),
                    text: e,
                  ),
                )
                .toList(),
            me: me,
            bot: bot,
          ),
        ) {
    on<UserTextMessageSent>(_onUserTextMessageSent);
    _taskRepository.getTasks().listen((event) => _tasks = event);
  }

  final Uuid _uuid;
  final BlueprintRepository _blueprintRepository;
  final TaskRepository _taskRepository;
  Iterable<Task> _tasks;

  Future<void> _onUserTextMessageSent(
    UserTextMessageSent event,
    Emitter<AiAssistantChatState> emit,
  ) async {
    try {
      final message = event.message;

      final newMessage = types.TextMessage(
        id: _uuid.v4(),
        text: message.text,
        author: _user,
      );

      emit(
        state.copyWith(
          // AI is going to respond
          botIsTyping: true,
          messages: List.of(state.messages)..insert(0, newMessage),
        ),
      );

      final (blueprintPreview, textResult) =
          await _blueprintRepository.generateAIBlueprint(
        message.text,
        _tasks.toList(),
      );

      for (final item in blueprintPreview) {
        final taskData = {
          'task': (item.value as Task).title,
          'startTime': item.startTime,
          'endTime': item.endTime,
        };
        print('Adding blueprint item: ${taskData}');
        await _blueprintRepository.addBlueprintItem(
          task: item.value as Task,
          startTime: item.startTime,
          endTime: item.endTime,
        );
      }

      emit(
        state.copyWith(
          botIsTyping: false,
          messages: List.of(state.messages)
            ..insert(
              0,
              types.TextMessage(
                id: _uuid.v4(),
                text: textResult,
                author: _bot,
              ),
            ),
        ),
      );
    } catch (error, stackTrace) {
      print('Error: $error, StackTrace: $stackTrace');
      addError(error, stackTrace);
    }
  }
}