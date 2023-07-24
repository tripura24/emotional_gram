// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:emotion_gram/pages/view_video_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class RecordVideoPage extends StatefulWidget {
  final CameraDescription camera;
  const RecordVideoPage({Key? key, required this.camera}) : super(key: key);

  @override
  _RecordVideoPageState createState() => _RecordVideoPageState();
}

class _RecordVideoPageState extends State<RecordVideoPage> {
  late CameraController _controller;
  late List<CameraDescription> _cameras = [];
  List<String> videoUrls = []; // List to store the URLs of saved videos
  bool _isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameras = cameras;
        _controller = CameraController(
          _cameras[0],
          ResolutionPreset.medium,
        );
        await _controller.initialize();
        if (mounted) {
          setState(() {});
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('No cameras available'),
            content: const Text('No cameras are available on the device.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } on CameraException catch (e) {
      print('Error: ${e.code}\n${e.description}');
    }
  }

  void switchCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      final CameraDescription newCamera = _isFrontCamera
          ? _cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front)
          : _cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back);
      _controller = CameraController(
        newCamera,
        ResolutionPreset.medium,
      );
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ...

  Future<void> recordAndSaveVideo() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    final Directory directory = await getTemporaryDirectory();
    // ignore: unused_local_variable
    final String videoPath = '${directory.path}/${DateTime.now()}.mp4';

    await _controller.startVideoRecording(); // Start recording the video

    await Future.delayed(
        const Duration(seconds: 5)); // Simulate a 5-second video recording

    final XFile videoFile = await _controller
        .stopVideoRecording(); // Stop recording and get the video file
    final File capturedVideo = File(videoFile.path);

    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child(
        'videos/emotionalgram/${DateTime.now().toString()}.mp4'); // Modified line
    final UploadTask uploadTask = storageRef.putFile(capturedVideo);
    final TaskSnapshot snapshot = await uploadTask;

    if (snapshot.state == TaskState.success) {
      final String downloadURL = await storageRef.getDownloadURL();
      setState(() {
        videoUrls.add(downloadURL); // Add the URL to the list of video URLs
      });
    }
  }

// ...

  Future<void> pickVideoFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref().child(
          'videos/emotionalgram/${DateTime.now().toString()}.mp4'); // Modified line
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final downloadURL = await storageRef.getDownloadURL();
        setState(() {
          videoUrls.add(downloadURL); // Add the URL to the list of video URLs
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record a Video"),
      ),
      body: GestureDetector(
        onTap: () async {
          await recordAndSaveVideo();
        },
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: CameraPreview(_controller),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.videocam),
            onPressed: () async {
              await recordAndSaveVideo();
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            child: const Icon(Icons.video_library),
            onPressed: () async {
              await pickVideoFromGallery();
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            child: const Icon(Icons.switch_camera),
            onPressed: () {
              switchCamera();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Saved Videos:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: const Text('View Videos'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewVideosPage(videoUrls: videoUrls),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
