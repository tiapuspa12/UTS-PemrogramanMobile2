import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const DashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Username: ${user['username']}'),
            Text('Name: ${user['name']}'),
            Text('Email: ${user['email']}'),
            Text('Address: ${user['address']}'),
            Text('Phone: ${user['phone']}'),
          ],
        ),
      ),
    );
  }
}
