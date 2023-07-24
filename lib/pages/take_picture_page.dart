import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emotion_gram/pages/view_image_page.dart';

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({Key? key}) : super(key: key);

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  late CameraController _controller;
  late List<CameraDescription> _cameras = [];
  List<String> imageUrls = []; // List to store the URLs of saved images
  bool _isFrontCamera = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras[0],
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    if (mounted) {
      setState(() {});
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

  Future<void> captureAndSaveImage() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    final XFile imageFile =
        await _controller.takePicture(); // Capture the image

    final Directory directory = await getTemporaryDirectory();
    final String imagePath = '${directory.path}/${DateTime.now()}.png';

    final File capturedImage = File(imageFile.path);
    await capturedImage.copy(imagePath); // Save the image to the desired path

    final FirebaseStorage storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child(
        'images/emotionalgram/${DateTime.now().toString()}.png'); // Modified line
    final UploadTask uploadTask = storageRef.putFile(capturedImage);
    final TaskSnapshot snapshot = await uploadTask;

    if (snapshot.state == TaskState.success) {
      final String downloadURL = await storageRef.getDownloadURL();
      setState(() {
        imageUrls.add(downloadURL); // Add the URL to the list of image URLs
      });
    }
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref().child(
          'images/emotionalgram/${DateTime.now().toString()}.png'); // Modified line
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final downloadURL = await storageRef.getDownloadURL();
        setState(() {
          imageUrls.add(downloadURL); // Add the URL to the list of image URLs
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
        title: const Text("Take a Picture"),
      ),
      body: GestureDetector(
        onTap: () async {
          await captureAndSaveImage();
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
            child: const Icon(Icons.camera),
            onPressed: () async {
              await captureAndSaveImage();
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            child: const Icon(Icons.photo_library),
            onPressed: () async {
              await pickImageFromGallery();
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
                'Saved Images:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: const Text('View Images'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(

                      builder: (context) => ViewImagesPage(imageUrls: imageUrls),
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
