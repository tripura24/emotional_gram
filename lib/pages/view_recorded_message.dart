import 'package:emotion_gram/pages/edit_actual_message.dart';
import 'package:emotion_gram/pages/edit_delivery_details.dart';
import 'package:emotion_gram/pages/edit_recipient_details.dart';
import 'package:emotion_gram/pages/edit_schedule_message_page.dart';
import 'package:flutter/material.dart';

class ViewRecordedMessage extends StatefulWidget {
  const ViewRecordedMessage({Key? key}) : super(key: key);

  @override
  State<ViewRecordedMessage> createState() => _ViewRecordedMessageState();
}

class _ViewRecordedMessageState extends State<ViewRecordedMessage> {
  bool isFreeUser =
      false; // Example: Set this based on the user's subscription status

  // Function to check user upgrade status
  Future<bool> checkUserUpgradeStatus() async {
    // Simulating the backend check
    // You can replace this with your actual implementation to check if the user has upgraded or not
    await Future.delayed(const Duration(seconds: 2));

    // Return a boolean value indicating whether the user has upgraded or not
    return true; // Set it to true if the user has upgraded, false otherwise
  }

  @override
  void initState() {
    super.initState();
    checkUserUpgradeStatus().then((upgraded) {
      setState(() {
        isFreeUser = !upgraded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("View Recorded Messages"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset('assets/images/www.jpg'),
              ),
              if (isFreeUser)
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle free user without upgrade
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home_screen',
                      (route) => false,
                      arguments: 'Upgrade to access editing options',
                    );
                  },
                  icon: const Icon(Icons.upgrade),
                  label: const Text('Upgrade to Premium'),
                )
              else
                Column(
                  children: [
                    //EditScheduledMessagePage
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EditScheduledMessagePage()),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Scheduled Message'),
                    ),

                    //edit actual message
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditActualMessagePage(
                                initialMessage: 'Initial message here'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Actual Message'),
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle editing recipient details
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditRecipientDetailsPage()));
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Recipient Details'),
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle editing delivery details
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditDeliveryDetailsPage()));
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Delivery Details'),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              const Text("View Recorded Messages Page"),
            ],
          ),
        ),
      ),
    );
  }
}
