// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todo_api/bloc/todo_bloc.dart';
// import 'package:todo_api/screens/add_todo.dart';

// class TodoListPage extends StatelessWidget {
//   const TodoListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text("Todo"),
//           centerTitle: true,
//           backgroundColor: Colors.black),
//       body: BlocBuilder<TodoBloc, TodoState>(
//         builder: (context, state) {

//           if(state is TodoLoading){
//              return const Center(child: CircularProgressIndicator());
//           }else if(state is TodoLoaded){
//             final items = state.items;

//              return RefreshIndicator(
//             onRefresh: ()async{
//               context.read<TodoBloc>().add(FetchTodo());
//             },
//             child: ListView.builder(
//                 padding: const EdgeInsets.all(15),
//                 itemCount: items.length,
//                 itemBuilder: (context, index) {
//                   final item = items[index] as Map;
//                   final id = item['_id'] as String;
//                   return Card(
//                     color: Colors.black,
//                     child: ListTile(
//                       leading: CircleAvatar(
//                           backgroundColor: Colors.black,
//                           child: Text('${index + 1}')),
//                       title: Text(item['title']),
//                       subtitle: Text(item['description']),
//                       trailing: PopupMenuButton(onSelected: (value) {
//                         if (value == 'edit') {
//                           navigateTOEditPage(context,item);
//                         } else if (value == 'delete') {
//                           context.read<TodoBloc>().add(DeleteTodo(id: id));
//                         }
//                       }, itemBuilder: (context) {
//                         return [
//                           const PopupMenuItem(
//                             value: 'edit',
//                             child: Text('Edit'),
//                           ),
//                           const PopupMenuItem(
//                             value: 'delete',
//                             child: Text('Delete'),
//                           ),
//                         ];
//                       }),
//                     ),
//                   );
//                 }),
//           );

//           }else if (state is TodoError) {
//             return Center(child: Text(state.message));
//           }
//           return const Center(child: Text('No Todos',));
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           navigateTOAddPage(context);
//         },
//         label: const Text('Add Todo'),
//         shape: const StadiumBorder(),
//         backgroundColor: Colors.cyan,
//       ),
//     );
//   }

//   Future<void> navigateTOAddPage(BuildContext context) async {
//     final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
//     await Navigator.push(context, route);

//   }

//   Future<void> navigateTOEditPage(BuildContext context,Map item) async {
//     final route = MaterialPageRoute(
//         builder: (context) => AddTodoPage(
//               todo: item,
//             ));
//     await Navigator.push(context, route);

//   }

//   // void showErrorMessage(String message,BuildContext context) {
//   //   final snackbar = SnackBar(
//   //     content: Text(message),
//   //     backgroundColor: Colors.red,
//   //   );
//   //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
//   // }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/bloc/todo_bloc.dart';
import 'package:todo_api/screens/add_todo.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return const Center(child: Text('No Todos'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TodoBloc>().add(FetchTodo());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Card(
                    color: Colors.black,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Text('${index + 1}'),
                      ),
                      title: Text(item['title'],
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(item['description'],
                          style: const TextStyle(color: Colors.white)),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            navigateToEditPage(context, item);
                          } else if (value == 'delete') {
                            context.read<TodoBloc>().add(DeleteTodo(id: id));
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ];
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No Todos'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddPage(context);
        },
        label: const Text('Add Todo'),
        shape: const StadiumBorder(),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  void navigateToAddPage(BuildContext context) {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    Navigator.push(context, route);
  }

  void navigateToEditPage(BuildContext context, Map item) {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));
    Navigator.push(context, route);
  }
}
