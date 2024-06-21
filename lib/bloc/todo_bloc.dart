import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<FetchTodo>(_fetchtodo);
    on<AddTodo>(_addTodo);
    on<UpdateTodo>(_updateTodo);
    on<DeleteTodo>(_deleteTodo);
  }

  Future<void> _fetchtodo(FetchTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        final results = json['items'] as List;
        emit(TodoLoaded(items: results));
      } else {
        emit(const TodoError(message: 'Failed to fetch todos'));
      }
    } catch (e) {
      emit(const TodoError(message: 'Failed to fetch todos'));
    }
  }

  Future<void> _addTodo(AddTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final body = {
        "title": event.title,
        "description": event.description,
        "is_completed": false
      };
      const url = 'https://api.nstack.in/v1/todos';

      final uri = Uri.parse(url);

      final response = await http.post(uri,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 201) {
        add(FetchTodo());
      } else {
        emit(const TodoError(message: 'Failed to add todo'));
      }
    } catch (e) {
      emit(const TodoError(message: 'Failed to add todo'));
    }
  }

  Future<void> _updateTodo(UpdateTodo event, Emitter emit) async {
    emit(TodoLoading());

    try {
      final body = {
        "title": event.title,
        "description": event.description,
        "is_completed": false
      };
      final url = 'https://api.nstack.in/v1/todos/${event.id}';
      final uri = Uri.parse(url);

      final response = await http.put(uri,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        add(FetchTodo());
      } else {
        print(response.body);
        emit(const TodoError(message: 'Failed to add todo'));
      }
    } catch (e) {
      emit(const TodoError(message: 'Failed to add todo'));
    }
  }

  Future<void> _deleteTodo(DeleteTodo event, Emitter emit) async {
    emit(TodoLoading());
    try {
      final url = 'https://api.nstack.in/v1/todos/${event.id}';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        add(FetchTodo());
      } else {
        emit(const TodoError(message: 'Failed to delete todo'));
      }
    } catch (e) {
      emit(const TodoError(message: 'Failed to delete todo'));
    }
  }
}
