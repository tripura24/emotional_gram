import 'package:flutter/material.dart';

class EditActualMessagePage extends StatefulWidget {
  final String initialMessage;

  const EditActualMessagePage({
    Key? key,
    required this.initialMessage,
  }) : super(key: key);

  @override
  _EditActualMessagePageState createState() => _EditActualMessagePageState();
}

class _EditActualMessagePageState extends State<EditActualMessagePage> {
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.initialMessage);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Actual Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Enter Message',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Save the updated message
                // ignore: unused_local_variable
                String updatedMessage = _messageController.text;
                // Perform any necessary logic to save the updated message
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
