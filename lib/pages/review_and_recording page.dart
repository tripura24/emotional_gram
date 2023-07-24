import 'package:emotion_gram/pages/recipient_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class ReviewRecordingPage extends StatefulWidget {
  @override
  _ReviewRecordingPageState createState() => _ReviewRecordingPageState();
}

class _ReviewRecordingPageState extends State<ReviewRecordingPage> {
  // Audio Recorder
  FlutterSoundRecorder? audioRecorder;

  // Audio Player
  FlutterSoundPlayer? audioPlayer;

  // Recording status
  bool isRecording = false;
  String? recordedFilePath;

  @override
  void initState() {
    super.initState();
    audioRecorder = FlutterSoundRecorder();
    audioPlayer = FlutterSoundPlayer();
    openAudioRecorder();
  }

  @override
  void dispose() {
    stopRecording();
    audioPlayer?.closePlayer();
    super.dispose();
  }

  // Open the audio recorder
  void openAudioRecorder() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

      await audioRecorder?.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );

      setState(() {
        isRecording = true;
        recordedFilePath = path;
      });
    } catch (e) {
      print('Recording initialization failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review and Recording'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Recording status indicator
            Text(
              isRecording ? 'Recording...' : 'Not Recording',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            // Start/Stop recording button
            ElevatedButton(
              onPressed: () {
                if (isRecording) {
                  stopRecording();
                } else {
                  startRecording();
                }
              },
              child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            const SizedBox(height: 20),
            // Play recorded audio button
            ElevatedButton(
              onPressed: playRecordedAudio,
              child: const Text('Play Recorded Audio'),
            ),
            const SizedBox(height: 20),
            //button for reciepient page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipientPage(),
                  ),
                );
              },
              child: const Text('Yes proceed to Recipient Page'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to start recording
  Future<void> startRecording() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

      await audioRecorder?.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );

      setState(() {
        isRecording = true;
        recordedFilePath = path;
      });
    } catch (e) {
      print('Recording initialization failed: $e');
    }
  }

  // Function to stop recording
  Future<void> stopRecording() async {
    try {
      await audioRecorder?.stopRecorder();

      setState(() {
        isRecording = false;
      });
    } catch (e) {
      print('Recording stop failed: $e');
    }
  }

  // Function to play recorded audio
  void playRecordedAudio() async {
    if (recordedFilePath != null) {
      await audioPlayer?.startPlayer(
        fromURI: recordedFilePath!,
        codec: Codec.aacADTS,
      );
    }
  }
}
