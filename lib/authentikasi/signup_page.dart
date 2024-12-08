import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/authentikasi/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  String? _selectedBranch;
  String? _gender;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final List<String> branches = ['Palembang', 'Lahat', 'Prabumulih', 'Baturaja', 'Jambi'];
  final List<String> genders = ['Laki-laki', 'Perempuan'];

  Future<void> _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String username = _usernameController.text.trim();
    String dateOfBirth = _dateOfBirthController.text.trim();
    String branch = _selectedBranch ?? '';
    String gender = _gender ?? '';

    // Validasi input
    if (email.isEmpty || password.isEmpty || username.isEmpty || dateOfBirth.isEmpty || branch.isEmpty || gender.isEmpty) {
      _showSnackBar('Mohon isi semua data');
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar('Format email tidak valid');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _saveUserDataToFirestore(user, username, dateOfBirth, branch, gender);

        await user.sendEmailVerification();

        _showSnackBar('Pendaftaran berhasil! Silakan verifikasi email Anda');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e);
      _showSnackBar(errorMessage);
    } catch (e) {
      _showSnackBar('Signup gagal: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserDataToFirestore(User user, String username, String dateOfBirth, String branch, String gender) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference userRef = firestore.collection('users').doc(user.uid);

    try {
      await userRef.set({
        'email': user.email,
        'username': username,
        'dateOfBirth': dateOfBirth,
        'branch': branch,
        'gender': gender,
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error menyimpan data ke Firestore: $e");
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah digunakan';
      case 'weak-password':
        return 'Password terlalu lemah';
      case 'invalid-email':
        return 'Email tidak valid';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }

  bool _isValidEmail(String email) {
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    return RegExp(pattern).hasMatch(email);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _pickDateOfBirth() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      _dateOfBirthController.text = formattedDate;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 94, 150),
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 26, 94, 150),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Container(
                  width: 300,
                  height: 550,
                  child: Card(
                    elevation: 20,
                    shadowColor: const Color.fromARGB(255, 0, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: const Color.fromARGB(255, 26, 94, 150),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _dateOfBirthController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Tanggal Lahir',
                              border: OutlineInputBorder(),
                            ),
                            onTap: _pickDateOfBirth,
                          ),
                          const SizedBox(height: 10),
                          DropdownButton<String>(
                            value: _gender,
                            hint: const Text('Pilih Jenis Kelamin'),
                            items: genders.map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          DropdownButton<String>(
                            value: _selectedBranch,
                            hint: const Text('Pilih Cabang'),
                            items: branches.map((branch) {
                              return DropdownMenuItem<String>(
                                value: branch,
                                child: Text(branch),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBranch = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 26, 94, 150),),
                            onPressed: _signUp,
                            child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              'Sudah Punya Akun? Login',
                              style: TextStyle(color: Color.fromARGB(255, 26, 94, 150)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
