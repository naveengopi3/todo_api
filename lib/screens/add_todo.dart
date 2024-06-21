import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/bloc/todo_bloc.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController textController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      textController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              isEdit ? updateData() : submitform();
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.cyan),
            ),
            child: Text(isEdit ? 'Update' : 'Submit'),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;

    final id = todo!['_id'];
    final title = textController.text;
    final description = descriptionController.text;

    context
        .read<TodoBloc>()
        .add(UpdateTodo(id: id, title: title, description: description));
  }

  Future<void> submitform() async {
    final text = textController.text;
    final description = descriptionController.text;

    context
        .read<TodoBloc>()
        .add(AddTodo(title: text, description: description));
  }

  // void showSuccessMessage(String message) {
  //   final snackbar = SnackBar(content: Text(message));
  //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  // }

  // void showErrorMessage(String message) {
  //   final snackbar = SnackBar(
  //     content: Text(message),
  //     backgroundColor: Colors.red,
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
  // }
}
