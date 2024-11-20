import 'package:flutter/material.dart';

class Manajementugas extends StatefulWidget {
  const Manajementugas({super.key});

  @override
  State<Manajementugas> createState() => _ManajementugasState();
}

class _ManajementugasState extends State<Manajementugas> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedPriority = "Normal";
  String _selectedCategory = "Rapat";

  void _addTask() {
    if (_taskController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      setState(() {
        _tasks.add({
          'title': _taskController.text,
          'priority': _selectedPriority,
          'date': _dateController.text,
          'time': _timeController.text,
          'category': _selectedCategory,
          'description': _descriptionController.text,
        });
      });
      _taskController.clear();
      _dateController.clear();
      _timeController.clear();
      _descriptionController.clear();
      _selectedPriority = "Normal";
      _selectedCategory = "Rapat";
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Manajemen Jadwal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Form Input
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambahkan Jadwal Kegiatan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: 'Judul',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Tanggal',
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _timeController,
                            decoration: InputDecoration(
                              labelText: 'Jam',
                              prefixIcon: const Icon(Icons.access_time),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            readOnly: true,
                            onTap: () => _selectTime(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Prioritas: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _selectedPriority,
                          items: <String>[
                            'Tinggi',
                            'Sedang',
                            'Normal',
                            'Rendah',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Kategori: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _selectedCategory,
                          items: <String>[
                            'Rapat',
                            'Proyek Kecil',
                            'Proyek Besar',
                            'Pertemuan',
                            'Seminar',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Tambahkan Jadwal',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Task List

            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada jadwal.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        Color priorityColor;
                        switch (task['priority']) {
                          case 'Tinggi':
                            priorityColor = Colors.red;
                            break;
                          case 'Sedang':
                            priorityColor = Colors.amber;
                            break;
                          case 'Normal':
                            priorityColor = Colors.orange;
                            break;
                          case 'Rendah':
                            priorityColor = Colors.green;
                            break;
                          default:
                            priorityColor = Colors.grey;
                        }
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: priorityColor,
                              child: Text(
                                task['priority'][0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(task['title']),
                            subtitle: Text(
                              'Prioritas: ${task['priority']}\n'
                              'Kategori: ${task['category']}\n'
                              'Tanggal: ${task['date']} | Jam: ${task['time']}\n'
                              'Deskripsi: ${task['description']}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Manajementugas(),
  ));
}
