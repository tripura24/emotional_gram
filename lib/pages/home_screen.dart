import 'package:camera/camera.dart';
import 'package:emotion_gram/pages/record_message.dart';
import 'package:emotion_gram/pages/view_recorded_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emotion_gram/pages/user_service_page.dart';




class HomeScreen extends StatelessWidget {
  Future<void> _navigateToRecordMessage(BuildContext context) async {
    final cameras = await availableCameras();
    final CameraDescription camera = cameras.first;

       // Get the current user from FirebaseAuth
    final User? user = FirebaseAuth.instance.currentUser;

    
    // If the user is not null, it means they are logged in
    if (user != null) {
      // Check if the user has already been registered by checking their UID in the Firestore database
      final userService = UserService();
      final userDocSnapshot = await userService.getUserCredits(user.uid);

      // If the user document does not exist, it means this is the first time they are logging in
      if (userDocSnapshot == null) {
        // Register the new user with initial credits set to 3
        await userService.registerNewUser(user.uid);
      }

      // Update credits for the user, for example, set to 10
      int newCredits = 10;
      await userService.updateCredits(user.uid, newCredits);
    }



    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordMessage(camera: camera),
      ),
    );
  }

  HomeScreen({Key? key}) : super(key: key);

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("HomeScreen"),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset('assets/images/www.jpg'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final cameras = await availableCameras();
                // ignore: unused_local_variable
                final CameraDescription camera = cameras.first;

                // Handle record message button press
                // ignore: use_build_context_synchronously
                _navigateToRecordMessage(
                    context); // Pass the context to the method
              },
              icon: const Icon(Icons.mic),
              label: const Text('Record Message'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Handle view recorded messages button press
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewRecordedMessage(),
                  ),
                );
              },
              icon: const Icon(Icons.view_list),
              label: const Text('View Recorded Messages'),
            ),

            const SizedBox(height: 16),
//---------------------------------------------------
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to the "Buy Message Pack" page when the button is pressed
            //     Navigator.pushNamed(context, '/buy_message_pack');
            //   },
            //   child: const Text('Buy Message Pack'),
            // ),

//---------------------------------------------------

            Text("Logged in as: ${user?.email ?? 'Unknown'}"),
          ],
        ),
      ),
    );
  }
}
