import 'package:emotion_gram/pages/buy_message_pack_page.dart';
import 'package:flutter/material.dart';

class MessagePackItem extends StatelessWidget {
  final MessagePack pack;

  final int credits;

  MessagePackItem({required this.pack, required this.credits});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(pack.name),
      subtitle: Text('Price: Rs. ${pack.price}'),
      trailing: ElevatedButton(
        onPressed: credits >= pack.price
            ? () {
                showConfirmationDialog(context);
              }
            : null,
        child: Text('Buy Now'),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Purchase'),
          content: Text('Are you sure you want to purchase ${pack.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the purchase logic here
                // For example, you can deduct credits and grant the message pack

                // After handling the purchase, close the dialog
                Navigator.pop(context);
              },
              child: Text('Buy'),
            ),
          ],
        );
      },
    );
  }
}
