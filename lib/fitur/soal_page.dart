import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/fitur/gradebook_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  final String quizType;
  const QuizPage({Key? key, required this.quizType}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _remainingTime = 1800;
  late Timer _timer;
  bool _isQuizFinished = false;

  List<Question> _questions = [
    Question(
      questionText: "Apa fungsi utama dari tab Home di Microsoft Word?",
      options: ["Membuat diagram", "Mengatur teks dan paragraf", "Menyisipkan tabel", "Mengatur margin"],
      correctAnswer: "Mengatur teks dan paragraf",
    ),
    Question(
      questionText: "Bagaimana cara menyisipkan nomor halaman di dokumen Word?",
      options: ["Tab Insert > Page Numbers", "Tab Home > Page Setup", "Tab Design > Page Numbers", "Tab Layout > Page Numbers"],
      correctAnswer: "Tab Insert > Page Numbers",
    ),
    Question(
      questionText: "Apa ekstensi file default untuk dokumen Word?",
      options: [".xls", ".ppt", ".docx", ".pdf"],
      correctAnswer: ".docx",
    ),
    Question(
      questionText: "Fitur apa yang digunakan untuk membuat daftar isi otomatis?",
      options: ["Mail Merge", "Table of Contents", "Footnote", "Index"],
      correctAnswer: "Table of Contents",
    ),
    Question(
      questionText: "Bagaimana cara membuat dokumen menjadi dua kolom?",
      options: ["Tab Home", "Tab Insert", "Tab Layout", "Tab Review"],
      correctAnswer: "Tab Layout",
    ),
    Question(
      questionText: "Bagaimana menambahkan catatan kaki (footnote)?",
      options: ["Tab Insert > Footnote", "Tab References > Insert Footnote", "Tab Review > Comments", "Tab Home > Styles"],
      correctAnswer: "Tab References > Insert Footnote",
    ),
    Question(
      questionText: "Apa fungsi dari Track Changes?",
      options: ["Mengubah ukuran teks", "Melacak perubahan dalam dokumen", "Menambahkan catatan kaki", "Mengatur margin"],
      correctAnswer: "Melacak perubahan dalam dokumen",
    ),
    Question(
      questionText: "Bagaimana cara menambahkan gambar ke dokumen?",
      options: ["Tab Insert > Picture", "Tab Home > Image", "Tab Design > Add Picture", "Tab References > Picture"],
      correctAnswer: "Tab Insert > Picture",
    ),
    Question(
      questionText: "Apa fungsi dari shortcut Ctrl + S?",
      options: ["Membuka dokumen", "Menyimpan dokumen", "Menutup dokumen", "Membatalkan perubahan"],
      correctAnswer: "Menyimpan dokumen",
    ),
    Question(
      questionText: "Di mana kita dapat mengatur ukuran kertas di Word?",
      options: ["Tab Insert > Paper Size", "Tab Layout > Size", "Tab Design > Page Setup", "Tab File > Options"],
      correctAnswer: "Tab Layout > Size",
    ),
  ];

  Map<int, String?> _selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        _timer.cancel();
        _showResult(context);
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctAnswer) {
        score += 10;
      }
    }
    return score;
  }

  void _saveScore(int score, String subject) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$subject-${widget.quizType}', score);
  }

  void _showResult(BuildContext context) {
    int correctAnswers = _calculateScore();
    setState(() {
      _isQuizFinished = true;
    });

    _saveScore(correctAnswers, 'Microsoft Office Word For Business');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soal Ujian - ${widget.quizType}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Waktu Tersisa: ${_formatTime(_remainingTime)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Soal ${index + 1}: ${question.questionText}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ...question.options.map<Widget>((option) {
                            return RadioListTile<String>(
                              title: Text(option),
                              value: option,
                              groupValue: _selectedAnswers[index],
                              onChanged: _isQuizFinished ? null : (value) {
                                setState(() {
                                  _selectedAnswers[index] = value;
                                });
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (!_isQuizFinished)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _showResult(context);
                },
                child: const Text('Selesai'),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });
}
