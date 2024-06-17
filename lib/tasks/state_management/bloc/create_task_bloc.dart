import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:task_repository/task_repository.dart';

part 'create_task_event.dart';
part 'create_task_state.dart';

@injectable
class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> {
  CreateTaskBloc({
    required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        super(CreateTaskState()) {
    on<TitleChanged>(_onTitleChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<DueDateChanged>(_onDueDateChanged);
    on<PriorityChanged>(_onPriorityChanged);
    on<EstimatedTimeChanged>(_onEstimatedTimeChanged);
    on<CreateTaskSubmitted>(_onCreateTaskSubmitted);
  }

  final TaskRepository _taskRepository;

  void _onTitleChanged(TitleChanged event, Emitter<CreateTaskState> emit) {
    print('Title changed: ${event.title}');
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    DescriptionChanged event,
    Emitter<CreateTaskState> emit,
  ) {
    print('Title changed: ${event.description}');
    emit(state.copyWith(description: event.description));
  }

  void _onDueDateChanged(
    DueDateChanged event,
    Emitter<CreateTaskState> emit,
  ) {
    emit(state.copyWith(dueDate: event.dueDate));
  }

  void _onPriorityChanged(
    PriorityChanged event,
    Emitter<CreateTaskState> emit,
  ) {
    emit(state.copyWith(priority: event.priority));
  }

  void _onEstimatedTimeChanged(
    EstimatedTimeChanged event,
    Emitter<CreateTaskState> emit,
  ) {
    emit(state.copyWith(estimatedTime: event.estimatedTime));
  }

  Future<void> _onCreateTaskSubmitted(
    CreateTaskSubmitted event,
    Emitter<CreateTaskState> emit,
  ) async {
    print('Creating task: ${state.title}');
    try {
      await _taskRepository.createBlueprintTask(
        title: state.title!,
        description: state.description!,
        startDate: DateTime.now(),
        dueDate: state.dueDate,
        priority: state.priority!,
      );
    } catch (error, stackTrace) {
      print('Error creating task: $error');
      addError(error, stackTrace);
    }
  }
}