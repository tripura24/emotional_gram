import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ScheduleMessagePage extends StatefulWidget {
  final DateTime? selectedDate;
  final String message;

  const ScheduleMessagePage({
    Key? key,
    required this.selectedDate,
    required this.message,
  }) : super(key: key);

  @override
  _ScheduleMessagePageState createState() => _ScheduleMessagePageState();
}

class _ScheduleMessagePageState extends State<ScheduleMessagePage> {
  XFile? _pickedImage;

  void accessGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  void scheduleMessage() {
    // Implement message scheduling logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Message'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Selected Date: ${widget.selectedDate.toString()}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Message: ${widget.message}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: accessGallery,
                child: const Text('Add Photos/Videos'),
              ),
              const SizedBox(height: 16.0),
              if (_pickedImage != null)
                Image.file(
                  File(_pickedImage!.path),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: scheduleMessage,
                child: const Text('Schedule Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
