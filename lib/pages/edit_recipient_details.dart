import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditRecipientDetailsPage extends StatefulWidget {
  const EditRecipientDetailsPage({Key? key}) : super(key: key);

  @override
  _EditRecipientDetailsPageState createState() =>
      _EditRecipientDetailsPageState();
}

class _EditRecipientDetailsPageState extends State<EditRecipientDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isGiftRecipient = false;

  void _saveRecipientDetails() {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final address = _addressController.text;

    // TODO: Save recipient details to Firebase
    FirebaseFirestore.instance.collection('recipients').add({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'isGiftRecipient': _isGiftRecipient,
    }).then((_) {
      // Success! Recipient details saved.
      // You can navigate to another screen or show a success message.
    }).catchError((error) {
      // Error occurred while saving recipient details.
      // Handle the error appropriately, such as displaying an error message.
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
        title: const Text('Edit Recipient Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                enabled: true, // Allow user input
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: true, // Allow user input
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                ),
                keyboardType: TextInputType.phone,
                enabled: true, // Allow user input
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
                enabled: true, // Allow user input
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Checkbox(
                    value: _isGiftRecipient,
                    onChanged: (value) {
                      setState(() {
                        _isGiftRecipient = value!;
                      });
                    },
                  ),
                  const Text('Is Gift Recipient'),
                ],
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: _saveRecipientDetails,
                child: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  textStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
