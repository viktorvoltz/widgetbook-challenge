import 'package:flutter/material.dart';

import 'package:widgetbook_challenge/api/widgetbook_api.dart';

/// Home Page
class HomePage extends StatefulWidget {

  /// builds the Home Page.
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final widgetBookApi = WidgetbookApi();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? get _errorText {
    final text = _nameController.value.text;

    if (text.isEmpty) {
      return 'field is empty';
    }

    if (text.contains(RegExp('[0-9]'))) {
      return 'name has a number';
    }

    return null;
  }

  // ignore: avoid_void_async
  void _submit() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    try {
      await widgetBookApi.welcomeToWidgetbook(
        message: _nameController.value.text,
      );
      final snackBar = SnackBar(
      content: Text('welcome ${_nameController.value.text}',
      ),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on UnexpectedException {
      const faultySnackBar = SnackBar(
      content: Text('Error with server',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(faultySnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _nameController,
      builder: (ctx, TextEditingValue value, __) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  errorText: _errorText,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _errorText == null ? _submit : null,
              child: const Text('submit'),
            )
          ],
        );
      },
    );
  }
}
