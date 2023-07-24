// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordAudioPage extends StatefulWidget {
  const RecordAudioPage({Key? key}) : super(key: key);

  @override
  _RecordAudioPageState createState() => _RecordAudioPageState();
}

class _RecordAudioPageState extends State<RecordAudioPage> {
  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _audioPlayer;
  String _audioPath = '';
  bool _isRecording = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
  }

  @override
  void dispose() async {
    await _audioPlayer?.stopPlayer();
    await _audioRecorder?.stopRecorder();
    _audioPlayer = null;
    _audioRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Audio"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRecording)
              const Text(
                'Recording...',
                style: TextStyle(fontSize: 24),
              ),
            if (_audioPath.isNotEmpty && !_isRecording)
              ElevatedButton(
                onPressed: _isPlaying ? _stopPlaying : _startPlaying,
                child: Text(_isPlaying ? 'Stop Playing' : 'Play Recording'),
              ),
            ElevatedButton(
              onPressed: _requestMicrophonePermission, // Add this line
              child:
                  const Text('Request Microphone Permission'), // Add this line
            ),
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      // Permission granted, proceed with audio recording
      _startRecording();
    } else if (status.isDenied) {
      // Permission denied, show a snackbar or dialog to inform the user
      // and provide instructions to grant the permission manually
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Microphone permission denied. Please grant the permission manually in app settings.'),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, show a snackbar or dialog with instructions
      // to open app settings and grant the permission manually
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Microphone permission permanently denied. Please grant the permission manually in app settings.'),
          action: SnackBarAction(
            label: 'SETTINGS',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    }
  }

  Future<void> _startRecording() async {
    if (_audioRecorder != null && !_isRecording) {
      final directory = Directory.systemTemp;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.aac';
      _audioPath = '${directory.path}/$fileName';

      try {
        // await _audioRecorder!.openAudioSession();
        await _audioRecorder!.startRecorder(
          codec: Codec.aacADTS,
          toFile: _audioPath,
        );
        setState(() {
          _isRecording = true;
        });
      } catch (e) {
        print('Failed to start audio recording: $e');
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_audioRecorder != null && _isRecording) {
      try {
        await _audioRecorder!.stopRecorder();
        setState(() {
          _isRecording = false;
        });
        print('Audio recorded at: $_audioPath');
      } catch (e) {
        print('Failed to stop audio recording: $e');
      }
      // } finally {
      //   _audioRecorder = null; // Release the FlutterSoundRecorder instance
      // }
    }
  }

  Future<void> _startPlaying() async {
    if (_audioPlayer != null && !_isPlaying) {
      try {
        await _audioPlayer!.startPlayer(
          fromURI: _audioPath,
          codec: Codec.aacADTS,
        );
        setState(() {
          _isPlaying = true;
        });
      } catch (e) {
        print('Failed to start audio playback: $e');
      }
    }
  }

  Future<void> _stopPlaying() async {
    if (_audioPlayer != null && _isPlaying) {
      try {
        await _audioPlayer!.stopPlayer();
        setState(() {
          _isPlaying = false;
        });
      } catch (e) {
        print('Failed to stop audio playback: $e');
      } finally {
        _audioPlayer = null; // Release the FlutterSoundPlayer instance
      }
    }
  }
}
