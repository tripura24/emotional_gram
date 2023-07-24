import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:emotion_gram/pages/schedule_message_page.dart';

class EditScheduledMessagePage extends StatefulWidget {
  const EditScheduledMessagePage({Key? key}) : super(key: key);

  @override
  _EditScheduledMessagePageState createState() =>
      _EditScheduledMessagePageState();
}

class _EditScheduledMessagePageState extends State<EditScheduledMessagePage> {
  late TextEditingController _messageController;
  late CalendarFormat _calendarFormat;
  DateTime _focusedDay = DateTime.now();
  DateTime _firstDay = DateTime.utc(2021, 1, 1);
  DateTime _lastDay = DateTime.utc(2030, 12, 31);
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _calendarFormat = CalendarFormat.month;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void proceedToNextPage() {
    // Navigate to the next page where you can schedule the message
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleMessagePage(
          selectedDate: _selectedDate,
          message: _messageController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Scheduled Message'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: _firstDay,
                lastDay: _lastDay,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                selectedDayPredicate: (day) {
                  return isSameDay(day, _selectedDate);
                },
              ),
              const SizedBox(height: 16.0),
              if (_selectedDate != null)
                Text(
                  'Selected Date: ${_selectedDate.toString()}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ElevatedButton(
                onPressed: _selectedDate != null ? proceedToNextPage : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

