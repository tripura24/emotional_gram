import 'package:emotion_gram/pages/message_pack_item.dart';
import 'package:emotion_gram/pages/user_service_page.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth if not already done
import 'package:flutter/material.dart';

class BuyMessagePackPage extends StatefulWidget {
  final bool isPremiumUser;

  BuyMessagePackPage({required this.isPremiumUser});

  @override
  _BuyMessagePackPageState createState() => _BuyMessagePackPageState();
}

class _BuyMessagePackPageState extends State<BuyMessagePackPage> {
  //added---------------
  UserService _userService = UserService();
  //----------------------
  int credits = 3; // Initial credits for first-time users
  String promoCode = '';
  bool isValidPromo = false;
  List<MessagePack> messagePacks = [
    MessagePack(name: 'Pack of 3', price: 29),
    MessagePack(name: 'Pack of 6', price: 49),
    MessagePack(name: 'Pack of 9', price: 69),
  ];
  //--------------------
  @override
  void initState() {
    super.initState();
    // Check if it's a new user, and if so, register them with initial credits.
    if (widget.isPremiumUser) {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          // User is logged in, check if it's a new user
          _userService.registerNewUser(user.uid);
        }
      });
    }
  }

//--------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Message Pack'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ... (previously defined widgets)
            const SizedBox(height: 20),
            const Text('Available Message Packs:'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: messagePacks.length,
                itemBuilder: (context, index) {
                  final pack = messagePacks[index];
                  return MessagePackItem(
                    pack: pack,
                    credits: credits,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validatePromoCode(String promoCode) {
    // Implement promo code validation logic here
    // For example, check if the promo code is registered with the sales team
    // Return true if the promo code is valid, false otherwise
    // You can make API calls to validate the promo code on the server side
    return promoCode.isNotEmpty && promoCode == 'YOUR_PROMO_CODE';
  }
}

class MessagePack {
  final String name;
  final int price;

  MessagePack({required this.name, required this.price});
}
