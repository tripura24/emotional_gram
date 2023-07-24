import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late FlutterSoundRecorder audioRecorder;
  late CameraController cameraController;
  File? imageFile;
  bool isRecording = false;
  late CameraDescription camera;
  XFile? videoFile;
  bool isVideoRecording = false;

  @override
  void initState() {
    super.initState();
    setupCamera();
    audioRecorder = FlutterSoundRecorder();
  }

  Future<void> setupCamera() async {
    final cameras = await availableCameras();
    setState(() {
      camera = cameras.first;
      cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
      );
      cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  void startAudioRecording() async {
    final appDir = await getTemporaryDirectory();
    final filePath =
        '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp3';

    await audioRecorder.startRecorder(toFile: filePath, codec: Codec.aacMP4);

    setState(() {
      isRecording = true;
    });
  }

  void stopAudioRecording() async {
    await audioRecorder.stopRecorder();

    setState(() {
      isRecording = false;
    });
    // Do something with the recorded audio
  }

  void captureImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void startVideoRecording() async {
    if (!cameraController.value.isRecordingVideo) {
      await cameraController.startVideoRecording();

      setState(() {
        isVideoRecording = true;
      });
    }
  }

  void stopVideoRecording() async {
    if (cameraController.value.isRecordingVideo) {
      await cameraController.stopVideoRecording();
      setState(() {
        isVideoRecording = false;
      });
      // Do something with the video file
    }
  }

  @override
  void dispose() {
    audioRecorder.stopRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Page'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Audio Recording'),
            trailing: isRecording
                ? IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: stopAudioRecording,
                  )
                : IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: startAudioRecording,
                  ),
          ),
          ListTile(
            title: const Text('Image Capture'),
            trailing: IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: captureImage,
            ),
          ),
          Expanded(
            child: imageFile != null ? Image.file(imageFile!) : Container(),
          ),
          ListTile(
            title: const Text('Video Recording'),
            trailing: isVideoRecording
                ? IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: stopVideoRecording,
                  )
                : IconButton(
                    icon: const Icon(Icons.videocam),
                    onPressed: startVideoRecording,
                  ),
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: cameraController.value.aspectRatio,
              child: CameraPreview(cameraController),
            ),
          ),
        ],
      ),
    );
  }
}
