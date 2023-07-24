import 'package:flutter/material.dart';

class EditDeliveryDetailsPage extends StatefulWidget {
  const EditDeliveryDetailsPage({Key? key}) : super(key: key);

  @override
  _EditDeliveryDetailsPageState createState() => _EditDeliveryDetailsPageState();
}

class _EditDeliveryDetailsPageState extends State<EditDeliveryDetailsPage> {
  late TextEditingController _addressController;
  late TextEditingController _contactNameController;
  late TextEditingController _contactPhoneController;
  late DateTime _selectedDate = DateTime.now();
  late TimeOfDay _selectedTime = TimeOfDay.now();
  late TextEditingController _specialInstructionsController;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _contactNameController = TextEditingController();
    _contactPhoneController = TextEditingController();
    _specialInstructionsController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveDeliveryDetails() {
    final address = _addressController.text;
    final contactName = _contactNameController.text;
    final contactPhone = _contactPhoneController.text;
    final deliveryDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    final specialInstructions = _specialInstructionsController.text;

    // TODO: Save delivery details to your desired storage or database

    // Print the values for demonstration
    print('Address: $address');
    print('Contact Name: $contactName');
    print('Contact Phone: $contactPhone');
    print('Delivery Date & Time: $deliveryDateTime');
    print('Special Instructions: $specialInstructions');

    // You can perform further actions such as navigating to another screen or showing a success message.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Delivery Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _contactNameController,
                decoration: const InputDecoration(
                  labelText: 'Contact Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _contactPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Contact Phone Number',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Delivery Date',
                        ),
                        child: Text(
                          '${_selectedDate.toLocal()}'.split(' ')[0],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Delivery Time',
                        ),
                        child: Text(
                          '${_selectedTime.format(context)}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _specialInstructionsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Special Instructions',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveDeliveryDetails,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
