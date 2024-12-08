import 'package:flutter/material.dart';
import 'package:myapp/fitur/soal_page.dart';

Widget buildTabContent(String triwulan, List<String> materiList) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        triwulan,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      ...materiList.map(
        (materi) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            materi,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    ],
  );
}

class TriwulanPage extends StatelessWidget {
  const TriwulanPage({Key? key}) : super(key: key);

  void _navigateToQuizPage(BuildContext context, String materi, String quizType) {
    if (quizType == 'Q1') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Q1Page(namaMateri: materi),
        ),
      );
    } else if (quizType == 'Q2') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Q2Page(namaMateri: materi),
        ),
      );
    } else if (quizType == 'Final') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FinalPage(namaMateri: materi),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Materi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          buildTabContent('TRIWULAN 1', [
            'Microsoft Office Word For Business',
            'Microsoft Office Excel For Business',
            'Microsoft Office PowerPoint For Business',
            'Aplikasi Teknologi Informasi dan SOHO Networking'
          ], context),
          const SizedBox(height: 20),
          buildTabContent('TRIWULAN 2', [
            'Ui Ux Desain',
            'Aplikasi Web CMS',
            'Web Programming'
          ], context),
          const SizedBox(height: 20),
          buildTabContent('TRIWULAN 3', [
            'Desain Grafis KIB',
            'Mobile Programming'
          ], context),
          const SizedBox(height: 20),
          buildTabContent('TRIWULAN 4', [
            'Digital Marketing KIBD',
            'Content Creation',
            'Desain Sprint'
          ], context),
        ],
      ),
    );
  }

  Widget buildTabContent(String triwulan, List<String> materiList, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          triwulan,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...materiList.map(
          (materi) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              children: [
                Text(
                  materi,
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () {
                    String quizType = triwulan == 'TRIWULAN 1' ? 'Q1' :
                                      triwulan == 'TRIWULAN 2' ? 'Q2' : 'Final';
                    _navigateToQuizPage(context, materi, quizType);
                  },
                  child: const Text('Mulai Ujian'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class Q1Page extends StatelessWidget {
  final String namaMateri;

  const Q1Page({Key? key, required this.namaMateri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 94, 150),
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: Card(
            elevation: 20,
            shadowColor: const Color.fromARGB(255, 0, 0, 0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      '$namaMateri',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nama Instruktur',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jenis Ujian: Q1',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jumlah Soal: 10 Soal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Waktu: 30 Menit',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Pindah ke halaman quiz
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizPage( quizType: 'Q1',),
                          ),
                        );
                      },
                      child: const Text('Mulai Ujian'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Menutup aplikasi
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Konfirmasi"),
                            content: const Text("Apakah Anda yakin ingin keluar?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                                child: const Text("Keluar"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Tutup'),
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

class Q2Page extends StatelessWidget {
  final String namaMateri;

  const Q2Page({Key? key, required this.namaMateri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 94, 150),
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: Card(
            elevation: 20,
            shadowColor: const Color.fromARGB(255, 0, 0, 0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      '$namaMateri',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nama Instruktur',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jenis Ujian: Q2',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jumlah Soal: 10 Soal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Waktu: 30 Menit',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Pindah ke halaman quiz
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizPage( quizType: 'Q2',),
                          ),
                        );
                      },
                      child: const Text('Mulai Ujian'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Menutup aplikasi
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Konfirmasi"),
                            content: const Text("Apakah Anda yakin ingin keluar?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                                child: const Text("Keluar"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Tutup'),
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

class FinalPage extends StatelessWidget {
  final String namaMateri;

  const FinalPage({Key? key, required this.namaMateri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 94, 150),
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: Card(
            elevation: 20,
            shadowColor: const Color.fromARGB(255, 0, 0, 0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    Text(
                      '$namaMateri',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const Text(
                      'Nama Instruktur',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jenis Ujian: Final',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jumlah Soal: 10 Soal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Waktu: 30 Menit',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Pindah ke halaman quiz
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizPage( quizType: 'Final',),
                          ),
                        );
                      },
                      child: const Text('Mulai Ujian'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Menutup aplikasi
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Konfirmasi"),
                            content: const Text("Apakah Anda yakin ingin keluar?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                                child: const Text("Keluar"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Tutup'),
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
