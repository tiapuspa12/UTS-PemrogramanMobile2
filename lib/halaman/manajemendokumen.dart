import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class ManajemenDokumen extends StatefulWidget {
  const ManajemenDokumen({super.key});

  @override
  ManajemenDokumenState createState() => ManajemenDokumenState();
}

class ManajemenDokumenState extends State<ManajemenDokumen> {
  final List<File> _documents = [];
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 20),
            _buildFeatureButtons(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.teal,
      title: const Text(
        'Manajemen Dokumen',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 5,
    );
  }

  Widget _buildHeader() {
    return Text(
      'Kelola Dokumen Anda dengan Mudah',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.teal.shade900,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFeatureButtons() {
    return Column(
      children: [
        _buildFeatureButton(
          icon: Icons.storage,
          title: "Penyimpanan Dokumen",
          description: "Simpan file penting dan akses kapan saja.",
          onPressed: () => _navigateToDocumentStorage(context),
        ),
        _buildFeatureButton(
          icon: Icons.scanner,
          title: "Pemindai Dokumen",
          description: "Pindai dokumen fisik menjadi format digital.",
          onPressed: _scanDocument,
        ),
        _buildFeatureButton(
          icon: Icons.share,
          title: "Berbagi Dokumen",
          description: "Bagikan dokumen melalui aplikasi atau email.",
          onPressed: _shareSelectedDocument,
        ),
        _buildFeatureButton(
          icon: Icons.upload_file,
          title: "Pilih File",
          description: "Pilih dokumen dari file system.",
          onPressed: _pickFile,
        ),
      ],
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade700,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.teal.shade700),
        onTap: onPressed,
      ),
    );
  }

  Future<void> _scanDocument() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final savedImage = File(
          '${directory.path}/document_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await pickedFile.saveTo(savedImage.path);
      setState(() {
        _documents.add(savedImage);
      });
      _showSnackbar('Dokumen dipindai dan disimpan!');
    } else {
      _showSnackbar('Pemindaian dibatalkan.');
    }
  }

  Future<void> _shareSelectedDocument() async {
    if (_documents.isEmpty) {
      _showSnackbar('Tidak ada dokumen untuk dibagikan!');
      return;
    }

    final selectedFiles = await _showFileSelectionDialog();
    if (selectedFiles.isNotEmpty) {
      final xFiles = selectedFiles.map((file) => XFile(file.path)).toList();
      await Share.shareXFiles(xFiles,
          text: 'Berikut dokumen yang saya bagikan.');
      _showSnackbar('Dokumen berhasil dibagikan.');
    }
  }

  Future<List<File>> _showFileSelectionDialog() async {
    final selectedFiles = <File>[];
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Dokumen untuk Dibagikan'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _documents.length,
              itemBuilder: (context, index) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    bool isSelected = selectedFiles.contains(_documents[index]);

                    return CheckboxListTile(
                      title: Text('Dokumen ${index + 1}'),
                      value: isSelected,
                      onChanged: (isChecked) {
                        setState(() {
                          if (isChecked == true) {
                            selectedFiles.add(_documents[index]);
                          } else {
                            selectedFiles.remove(_documents[index]);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, selectedFiles),
              child: const Text('Bagikan'),
            ),
          ],
        );
      },
    );
    return selectedFiles;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.single.path!);
      setState(() {
        _documents.add(file);
      });
      _showSnackbar('File dipilih dan disimpan!');
    } else {
      _showSnackbar('Tidak ada file yang dipilih.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToDocumentStorage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentStoragePage(documents: _documents),
      ),
    );
  }
}

class DocumentStoragePage extends StatelessWidget {
  final List<File> documents;

  const DocumentStoragePage({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Penyimpanan Dokumen"),
      ),
      body: documents.isEmpty
          ? const Center(child: Text("Tidak ada dokumen yang disimpan."))
          : ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading:
                      const Icon(Icons.insert_drive_file, color: Colors.teal),
                  title: Text('Dokumen ${index + 1}'),
                  subtitle: Text(documents[index].path.split('/').last),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Menghapus dokumen dari list
                      documents.removeAt(index);
                      // Memperbarui tampilan
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            DocumentStoragePage(documents: documents),
                      ));
                    },
                  ),
                  onTap: () {
                    OpenFile.open(documents[index].path);
                  },
                );
              },
            ),
    );
  }
}
