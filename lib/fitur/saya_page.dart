import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/authentikasi/edit_page.dart';
import 'package:myapp/authentikasi/login_page.dart';
import 'package:myapp/authentikasi/change_password_page.dart'; // Pastikan mengimpor halaman ChangePasswordPage

class SayaPage extends StatefulWidget {
  const SayaPage({Key? key}) : super(key: key);

  @override
  State<SayaPage> createState() => _SayaPageState();
}

class _SayaPageState extends State<SayaPage> {
  String username = '';
  String email = '';
  String dateOfBirth = '';
  String branch = '';
  String gender = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
        
        setState(() {
          username = userData['username'] ?? '';
          email = user.email ?? '';
          dateOfBirth = userData['dateOfBirth'] ?? '';
          branch = userData['branch'] ?? '';
          gender = userData['gender'] ?? '';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data pengguna: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda berhasil logout')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat logout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              Text('Tanggal Lahir: $dateOfBirth', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Cabang: $branch', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Jenis Kelamin: $gender', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit, color: Color.fromARGB(255, 26, 94, 150)),
                title: const Text('Edit Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPage(
                        username: username,
                        dateOfBirth: dateOfBirth,
                        branch: branch,
                        gender: gender,
                        onProfileUpdated: (updatedUsername, updatedDateOfBirth, updatedBranch, updatedGender) {
                          setState(() {
                            username = updatedUsername;
                            dateOfBirth = updatedDateOfBirth;
                            branch = updatedBranch;
                            gender = updatedGender;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Color.fromARGB(255, 26, 94, 150)),
                title: const Text('Change Password'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Color.fromARGB(255, 26, 94, 150)),
                title: const Text('Log Out'),
                onTap: () {
                  logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
