import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

/// A read-only description of a todo-item
class Todo {
  Todo({
    this.description,
    this.completed = false,
    String id,
  }) : id = id ?? _uuid.v4();

  final String id;
  final String description;
  final bool completed;

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }
}

/// An object that controls a list of [Todo].
class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo> initialTodos]) : super(initialTodos ?? []);

  void add(String description) {
    // stateへの代入が状態の更新となる
    state = [
      ...state,
      Todo(description: description),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
  }

  void edit({@required String id, @required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
  }

  void remove(Todo target) {
    // 削除の時もstateを更新
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
