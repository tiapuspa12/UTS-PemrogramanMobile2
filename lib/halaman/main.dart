import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tia PemMob 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Halaman beranda
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat Datang di Aplikasi PemMob',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward),
                  SizedBox(width: 8),
                  Text('Login', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward),
                  SizedBox(width: 8),
                  Text('Register', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Pastikan data user valid sebelum navigasi
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardPage(user: const {
                            'username':
                                'default_user', // Ganti dengan data yang sesuai
                            'name':
                                'User Default', // Ganti dengan data yang sesuai
                            'email':
                                'user@example.com', // Ganti dengan data yang sesuai
                            'address':
                                'Default Address', // Ganti dengan data yang sesuai
                            'phone':
                                '0123456789', // Ganti dengan data yang sesuai
                          })),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward),
                  SizedBox(width: 8),
                  Text('Dashboard', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
