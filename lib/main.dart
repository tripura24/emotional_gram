import 'package:camera/camera.dart';
import 'package:emotion_gram/pages/auth_page.dart';
import 'package:emotion_gram/pages/buy_message_pack_page.dart';
import 'package:emotion_gram/pages/dashboard_Screen.dart';
import 'package:emotion_gram/pages/edit_actual_message.dart';
import 'package:emotion_gram/pages/edit_delivery_details.dart';
import 'package:emotion_gram/pages/edit_recipient_details.dart';
import 'package:emotion_gram/pages/edit_schedule_message_page.dart';
import 'package:emotion_gram/pages/record_audio_page.dart';
import 'package:emotion_gram/pages/record_message.dart';
import 'package:emotion_gram/pages/record_video_page.dart';
import 'package:emotion_gram/pages/registration_screen.dart';
import 'package:emotion_gram/pages/review_page.dart';
import 'package:emotion_gram/pages/take_picture_page.dart';
import 'package:emotion_gram/pages/view_recorded_message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
 import 'package:emotion_gram/pages/home_screen.dart';

//  import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  await Firebase.initializeApp();
  runApp(MyApp(camera: firstCamera))  ;
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Authentication',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/HomeScreen': (context) =>  HomeScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/record_message': (context) => RecordMessage(camera: camera),
        '/view_recorded_messages': (context) => const ViewRecordedMessage(),
        '/record_audio': (context) => const RecordAudioPage(),
        '/record_video': (context) => RecordVideoPage(camera: camera),
        '/take_picture': (context) => const TakePicturePage(),
        '/ReviewPage': (context) => const ReviewPage(),
        '/edit_scheduled_message': (context) =>
            const EditScheduledMessagePage(),
        '/edit_actual_message': (context) =>
            const EditActualMessagePage(initialMessage: 'Initial message here'),
        '/edit_recipient_details': (context) =>
            const EditRecipientDetailsPage(),
        '/edit_delivery_details': (context) => const EditDeliveryDetailsPage(),
        '/buy_message_pack': (context) => BuyMessagePackPage(
              isPremiumUser:
                  true, // Set to true for premium users, false for free users
            ),
      },
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Home page'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Image.asset(
//               'assets/images/w.jpg',
//             ),
//             const Text(
//               "WELCOME",
//               style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue),
//             ),
//             const SizedBox(height: 30.0),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/registration');
//               },
//               child: const Text('Register'),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/login');
//               },
//               child: const Text('Login'),
//             ),
//             const SizedBox(
//               height: 16.0,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/dashboard');
//               },
//               child: const Text('Dashnoard_Screen'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
