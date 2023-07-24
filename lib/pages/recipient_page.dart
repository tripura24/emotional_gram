import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipientPage extends StatefulWidget {
  @override
  _RecipientPageState createState() => _RecipientPageState();
}

class _RecipientPageState extends State<RecipientPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _saveRecipientDetails() {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;
    final String address = _addressController.text;

    // Store the recipient details in Firebase Firestore
    FirebaseFirestore.instance.collection('recipients').add({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    }).then((value) {
      // Success
      print('Recipient details saved successfully!');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Recipient details saved successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      // Error
      print('Failed to save recipient details: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save recipient details: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void fetchRecipientData() {
    FirebaseFirestore.instance
        .collection('recipients')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Access the data for each recipient document
        final name = doc.data()['name'];
        final email = doc.data()['email'];
        final phone = doc.data()['phone'];
        final address = doc.data()['address'];

        // Do something with the recipient data
        print('Name: $name');
        print('Email: $email');
        print('Phone: $phone');
        print('Address: $address');
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipient Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            ElevatedButton(
              onPressed: _saveRecipientDetails,
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: fetchRecipientData,
              child: const Text('Fetch Recipient Data'),
            ),
          ],
        ),
      ),
    );
  }
}
