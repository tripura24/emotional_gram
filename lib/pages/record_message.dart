import 'package:emotion_gram/pages/record_audio_page.dart';
import 'package:emotion_gram/pages/record_video_page.dart';
import 'package:emotion_gram/pages/review_and_recording%20page.dart';
import 'package:emotion_gram/pages/take_picture_page.dart';
import 'package:flutter/material.dart';
import 'package:emotion_gram/pages/user_service_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


class RecordMessage extends StatefulWidget {
  final dynamic camera;

  const RecordMessage({Key? key, required this.camera}) : super(key: key);

  @override
  State<RecordMessage> createState() => _RecordMessageState();
}

class _RecordMessageState extends State<RecordMessage> {
  bool hasMessageCredits = false;



  @override
  void initState() {
    super.initState();
    performBackendCheck();
  }

  Future<void> performBackendCheck() async {
  // Simulate backend check (you can replace this with actual backend API call)
  await Future.delayed(const Duration(seconds: 2));

  bool backendCheckResult = true;

  // Get the current user from FirebaseAuth
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Check if the user has already been registered by checking their UID in the Firestore database
    final userService = UserService();
    final userDocSnapshot = await userService.getUserCredits(user.uid);

    // If the user document does not exist, it means this is the first time they are logging in
    if (userDocSnapshot == null) {
      // Register the new user with initial credits set to 3
      await userService.registerNewUser(user.uid, credits: 3);
    }

    // Update the hasMessageCredits state based on the user's message credits
    // You can implement the UserService method to get the user's message credits.
    int userCredits = await userService.getUserCredits(user.uid);
    setState(() {
      hasMessageCredits = backendCheckResult && userCredits > 0;
    });
  } else {
    setState(() {
      hasMessageCredits = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Message"),
      ),
      body: Center(
        child: hasMessageCredits
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/www.jpg'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecordVideoPage(camera: widget.camera),
                        ),
                      );
                    },
                    icon: const Icon(Icons.videocam),
                    label: const Text("Record Video"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecordAudioPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.mic),
                    label: const Text("Record Audio"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TakePicturePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Take a Picture"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewRecordingPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.record_voice_over),
                    label: const Text("Review and Recording"),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/buy_message_pack');
                },
                child: const Text("Buy Message Pack"),
              ),
      ),
    );
  }
}
