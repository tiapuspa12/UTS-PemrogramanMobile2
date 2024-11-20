import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tia_pemmob2/db/database.dart';
import 'package:tia_pemmob2/halaman/datadiri.dart';
import 'package:tia_pemmob2/halaman/manajemendokumen.dart';
import 'package:tia_pemmob2/halaman/manajemenjadwal.dart';
import 'login.dart';
import 'package:tia_pemmob2/halaman/setting.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  final int userId;

  const DashboardPage({super.key, required this.userId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? _userData;

  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "Meeting dengan Tim",
      "description": "Diskusi project baru",
      "date": DateTime.now().add(const Duration(hours: 1)),
      "completed": false,
    },
    {
      "title": "Deadline Proposal",
      "description": "Pengumpulan proposal akhir",
      "date": DateTime.now().add(const Duration(days: 1)),
      "completed": false,
    },
    {
      "title": "Review Dokumen",
      "description": "Revisi dokumen kontrak",
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "completed": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _sortNotifications();
  }

  Future<void> _fetchUserData() async {
    DatabaseHelper db = DatabaseHelper();
    final userData = await db.getUserById(widget.userId);

    setState(() {
      _userData = userData ?? {};
      _sortNotifications();
    });
  }

  void _openDataDiri() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Datadiri(userId: widget.userId),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.52,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 42.0),
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.9), // Latar belakang semi-transparan
                borderRadius:
                    BorderRadius.circular(10), // Sudut border melengkung
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Warna shadow
                    blurRadius: 10, // Tingkat blur
                    offset: const Offset(
                        0, 5), // Arah bayangan (horizontal, vertical)
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/bg1.jpg'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Colors.teal, // Warna border
                  width: 1.5, // Ketebalan border
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        (_userData != null && _userData?['foto'] != null)
                            ? FileImage(File(_userData?[
                                'foto'])) // Menggunakan File untuk foto lokal
                            : const AssetImage('assets/default_profile.png')
                                as ImageProvider,
                    child: (_userData != null && _userData?['foto'] == null)
                        ? const Icon(Icons.person, size: 65, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userData?['name'] ?? 'Nama Pengguna',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _userData?['email'] ?? 'Email belum diisi',
                    style: const TextStyle(
                      color: Color.fromARGB(212, 255, 255, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    color: Colors.teal, // Warna garis pembatas
                    thickness: 1,
                    height: 30,
                    indent: 50,
                    endIndent: 50,
                  ),
                ],
              ),
            ),

            // Tambahkan menu drawer dengan customListTile
            customListTile(
              icon: Icons.dashboard,
              title: "Dashboard",
              context: context,
              onTap: () => Navigator.pop(context),
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Colors.deepPurple.shade600,
            ),
            customListTile(
              icon: Icons.assignment_rounded,
              title: "Manajemen Dokumen",
              context: context,
              destinationPage: const ManajemenDokumen(),
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Colors.deepPurple.shade600,
            ),
            customListTile(
              icon: Icons.calendar_month_outlined,
              title: "Penjadwalan Kegiatan",
              context: context,
              destinationPage: const Manajementugas(),
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Colors.deepPurple.shade600,
            ),
            customListTile(
              icon: Icons.account_box_sharp,
              title: "Data Diri",
              context: context,
              onTap: _openDataDiri,
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Colors.deepPurple.shade600,
            ),
            customListTile(
              icon: Icons.manage_accounts_outlined,
              title: "Setting Profile",
              context: context,
              onTap: _opensetting,
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Colors.deepPurple.shade600,
            ),
            customListTile(
              icon: Icons.login_outlined,
              title: "Logout",
              context: context,
              onTap: _showLogoutConfirmation,
              iconColor: Colors.white,
              textColor: Colors.white,
              tileColor: Colors.deepPurple.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _opensetting() async {
    final userId = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingPage(userId: widget.userId),
      ),
    );
    if (userId != null) await _fetchUserData();
  }

  Future<void> _showLogoutConfirmation() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

// Mengurutkan notifikasi berdasarkan status dan tanggal
  void _sortNotifications() {
    _notifications.sort((a, b) {
      if (a['completed'] != b['completed']) {
        return a['completed'] ? 1 : -1; // Yang sudah selesai ke bawah
      }
      return b['date']
          .compareTo(a['date']); // Urutkan berdasarkan tanggal, terbaru di atas
    });
  }

// Menampilkan modal notifikasi dengan setState agar daftar diperbarui
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, modalSetState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Notifikasi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationTile(
                          notification, index, modalSetState);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// Menghitung jumlah notifikasi yang belum selesai
  int get _unfinishedNotifications {
    return _notifications
        .where((notification) => !notification['completed'])
        .length;
  }

// Membuat ikon notifikasi dengan badge
  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.yellow),
          onPressed: _showNotifications,
        ),
        if (_unfinishedNotifications > 0)
          Positioned(
            right: 8,
            top: 8,
            child: _buildNotificationBadge(),
          ),
      ],
    );
  }

// Membuat badge untuk jumlah notifikasi yang belum selesai
  Widget _buildNotificationBadge() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$_unfinishedNotifications',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

// Membuat tampilan ListTile untuk setiap notifikasi
  Widget _buildNotificationTile(
      Map<String, dynamic> notification, int index, StateSetter modalSetState) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(notification['title'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd MMM yyyy, HH:mm').format(notification['date']),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(notification['description'],
                style: const TextStyle(fontSize: 14)),
          ],
        ),
        trailing: Checkbox(
          value: notification['completed'],
          onChanged: (value) {
            setState(() {
              notification['completed'] = value!;
              _sortNotifications();
            });

            // Memperbarui tampilan modal
            modalSetState(() {});
          },
        ),
        tileColor:
            notification['completed'] ? Colors.green[50] : Colors.red[50],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [_buildNotificationIcon()],
      ),
      drawer: buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: _fetchUserData, // Fungsi refresh untuk memuat ulang data
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Selamat datang, ${_userData?['name'] ?? 'Pengguna'}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(
                            Icons.star_border_purple500,
                            color: Colors.amber, // Ubah warna sesuai kebutuhan
                          ),
                          Text(
                            'Tips Penggunaan Aplikasi:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1. Tekan notifikasi untuk menandainya selesai.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const Text(
                        '2. Refresh layar untuk memperbarui data dengan scroll ke bawah',
                        style: TextStyle(fontSize: 14),
                      ),
                      const Text(
                        '3. Simpan data di Menu Manajemen Dokumen agar aman.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const Text(
                        '4. Buat jadwal acara/kegiatan di Penjadwalan Kegiatan',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget customListTile({
  required IconData icon,
  required String title,
  required BuildContext context,
  Color iconColor = Colors.white,
  Color textColor = Colors.white,
  Color tileColor = Colors.deepPurple,
  VoidCallback? onTap, // Callback opsional untuk aksi
  Widget? destinationPage, // Halaman tujuan opsional
}) {
  return ListTile(
    leading: Icon(icon, color: iconColor),
    title: Text(
      title,
      style: TextStyle(color: textColor),
    ),
    tileColor: tileColor,
    onTap: onTap ??
        () {
          if (destinationPage != null) {
            // Navigasi ke halaman jika destinationPage disediakan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destinationPage),
            );
          }
        },
  );
}
