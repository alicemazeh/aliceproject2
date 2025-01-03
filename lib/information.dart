
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'payment_page.dart';
import 'delivery_progress.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key, required this.totalItemCount, required this.totalPrice});
  final int totalItemCount;
  final double totalPrice;

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();

  // Validation methods
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^\+?[0-9]+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Method to handle HTTP POST request
  Future<void> _submitData(String paymentMethod) async {
    if (!_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Please fill in all fields correctly before selecting a payment method.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Color(0xFFD3131D))),
            ),
          ],
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://alicemazeh2.atwebpages.com/saveOrders.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'country': _countryController.text,
        'city': _cityController.text,
        'street': _streetController.text,
        'building': _buildingController.text,
        'payment_method': paymentMethod,
        'total_price': widget.totalPrice,
        'total_item_count': widget.totalItemCount,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'success') {
        if (paymentMethod == 'Card') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaymentPage(totalItemCount: widget.totalItemCount, totalPrice: widget.totalPrice)),
          );
        } else if (paymentMethod == 'Cash') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeliveryProgressPage(totalItemCount: widget.totalItemCount, totalPrice: widget.totalPrice)),
          );
        }
      } else {
        // Handle error from the PHP script
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error', style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text('Failed to save data: ${responseBody['message']}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK', style: TextStyle(color: Color(0xFFD3131D))),
              ),
            ],
          ),
        );
      }
    } else {
      // Handle network errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Failed to connect to the server.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Color(0xFFD3131D))),
            ),
          ],
        ),
      );
    }
  }

  // Handle payment method button press
  void _handlePaymentMethod(String paymentMethod) {
    _submitData(paymentMethod);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Personal Info and Payment Methods',
          style: TextStyle(color: Colors.white, fontFamily: 'PlayfairDisplay'),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFD3131D),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10.0),
                const Text(
                  'Fill in your personal details:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'PlayfairDisplay',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                _buildTextField('Name', _nameController, _validateName),
                const SizedBox(height: 5.0),
                _buildTextField('Phone', _phoneController, _validatePhone),
                const SizedBox(height: 5.0),
                _buildTextField('Country', _countryController, _validateAddress),
                const SizedBox(height: 5.0),
                _buildTextField('City', _cityController, _validateAddress),
                const SizedBox(height: 5.0),
                _buildTextField('Street', _streetController, _validateAddress),
                const SizedBox(height: 5.0),
                _buildTextField('Building', _buildingController, _validateAddress),
                const SizedBox(height: 10.0),
                // Payment Section
                const Divider(color: Color(0xFFD3131D)),
                const Text(
                  'Select Payment Method:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'PlayfairDisplay',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPaymentButton('Card', () => _handlePaymentMethod('Card')),
                    const SizedBox(width: 20.0),
                    _buildPaymentButton('Cash', () => _handlePaymentMethod('Cash')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build text fields with validation
  Widget _buildTextField(String label, TextEditingController controller, [String? Function(String?)? validator]) {
    return SizedBox(
      width: 150, // Adjust the width to make the text field smaller
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD3131D), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xFFD3131D).withOpacity(0.5), width: 1.0),
          ),
        ),
        validator: validator,
        inputFormatters: label == 'Phone' ? [FilteringTextInputFormatter.digitsOnly] : null,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  // Build payment method buttons
  Widget _buildPaymentButton(String paymentMethod, VoidCallback onPressed) {
    return SizedBox(
      width: 140,
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFD3131D)),
          minimumSize: WidgetStateProperty.all<Size>(const Size(120, 40)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(paymentMethod, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
