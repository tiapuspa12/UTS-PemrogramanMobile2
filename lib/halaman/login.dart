import 'package:flutter/material.dart';
import 'package:tia_pemmob2/db/database.dart';
import 'dashboard.dart';
import 'package:tia_pemmob2/halaman/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    DatabaseHelper db = DatabaseHelper();

    Map<String, dynamic>? user = await db.loginUser(
      _usernameController.text,
      _passwordController.text,
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(userId: user['id']),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login gagal. Periksa Username dan Password anda')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: const Text('Login',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Selamat Datang',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildTextField(_usernameController, 'Username'),
                const SizedBox(height: 16),
                _buildTextField(_passwordController, 'Password',
                    obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Login',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  label: const Text(
                    'Belum punya akun? Daftar',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold), // Teks putih dan bold
                  ),
                  icon: const Icon(Icons.arrow_forward,
                      color: Colors.white), // Menambahkan ikon pada TextButton
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold), // Set font size and weight
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold), // Set font size and weight for label
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(15)), // Mengubah radius untuk border fokus
          borderSide: BorderSide(color: Colors.teal),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.text,
    );
  }
}
