import 'package:flutter/material.dart';
import 'package:tia_pemmob2/db/database.dart';

class SettingPage extends StatefulWidget {
  final int userId;

  SettingPage({required this.userId});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DatabaseHelper db = DatabaseHelper();
    final userData = await db.getUserById(widget.userId);
    if (userData != null) {
      setState(() {
        _nameController.text = userData['name'];
        _emailController.text = userData['email'];
        _addressController.text = userData['address'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _isLoading = false;
      });
    } else {
      _showErrorSnackbar('Error loading user data.');
    }
  }

  Future<void> _updateUserData() async {
    if (_validateInputs()) {
      DatabaseHelper db = DatabaseHelper();
      final updatedUser = {
        'name': _nameController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
      };

      final result = await db.updateUser(widget.userId, updatedUser);
      if (result > 0) {
        _showSuccessSnackbar('User data updated successfully!');
        Navigator.pop(context); // Return to the previous page
      } else {
        _showErrorSnackbar('Failed to update user data.');
      }
    }
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      _showErrorSnackbar('Name cannot be empty.');
      return false;
    }
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      _showErrorSnackbar('Please enter a valid email address.');
      return false;
    }
    return true;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21),
        backgroundColor: const Color.fromARGB(196, 219, 12, 153),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple[100]!,
                    const Color.fromARGB(255, 244, 90, 170),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(_nameController, 'Name'),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email',
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _buildTextField(_addressController, 'Address'),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Phone',
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 20),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _updateUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 231, 55, 140),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 18), // Set font size
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16), // Set font size for label
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(color: Color.fromARGB(255, 235, 49, 194)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
    );
  }
}
