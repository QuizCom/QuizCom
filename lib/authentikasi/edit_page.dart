import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditPage extends StatefulWidget {
  final String username;
  final String dateOfBirth;
  final String branch;
  final String gender;
  final Function(String, String, String, String) onProfileUpdated;

  const EditPage({
    Key? key,
    required this.username,
    required this.dateOfBirth,
    required this.branch,
    required this.gender,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  String? _selectedBranch;
  String? _gender;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username;
    _dateOfBirthController.text = widget.dateOfBirth;
    _selectedBranch = widget.branch;
    _gender = widget.gender;
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.dateOfBirth);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _saveData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Update data di Firestore
        await userDocRef.update({
          'username': _usernameController.text,
          'dateOfBirth': _dateOfBirthController.text,
          'branch': _selectedBranch ?? '',
          'gender': _gender ?? '',
        });

        widget.onProfileUpdated(
          _usernameController.text,
          _dateOfBirthController.text,
          _selectedBranch ?? '',
          _gender ?? '',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 26, 94, 150),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _dateOfBirthController,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Lahir',
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      value: _gender,
                      items: ['Laki-laki', 'Perempuan']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      value: _selectedBranch,
                      items: ['Palembang', 'Lahat', 'Prabumulih', 'Baturaja', 'Jambi']
                          .map((branch) => DropdownMenuItem(
                                value: branch,
                                child: Text(branch),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBranch = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 26, 94, 150),
                      ),
                      child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
