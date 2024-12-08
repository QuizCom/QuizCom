import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<int> loadScore(String subject, String quizType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$subject-$quizType') ?? 0;
  }

  Widget buildTabContent(String title, List<String> subjects) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Materi')),
                  DataColumn(label: Text('Q1')),
                  DataColumn(label: Text('Q2')),
                  DataColumn(label: Text('Final')),
                ],
                rows: subjects.map((subject) {
                  return DataRow(cells: [
                    DataCell(Text(subject)),
                    DataCell(FutureBuilder<int>(
                      future: loadScore(subject, 'Q1'),
                      builder: (context, snapshot) {
                        return Text(snapshot.data?.toString() ?? '0');
                      },
                    )),
                    DataCell(FutureBuilder<int>(
                      future: loadScore(subject, 'Q2'),
                      builder: (context, snapshot) {
                        return Text(snapshot.data?.toString() ?? '0');
                      },
                    )),
                    DataCell(FutureBuilder<int>(
                      future: loadScore(subject, 'Final'),
                      builder: (context, snapshot) {
                        return Text(snapshot.data?.toString() ?? '0');
                      },
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'TRIWULAN 1'),
            Tab(text: 'TRIWULAN 2'),
            Tab(text: 'TRIWULAN 3'),
            Tab(text: 'TRIWULAN 4'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildTabContent('TRIWULAN 1', [
            'Microsoft Office Word For Business',
            'Microsoft Office Excel For Business',
            'Microsoft Office PowerPoint For Business',
            'Aplikasi Teknologi Informasi dan SOHO Networking',
          ]),
          buildTabContent('TRIWULAN 2', [
            'UI UX Design',
            'Aplikasi Web CMS',
            'Web Programming',
          ]),
          buildTabContent('TRIWULAN 3', [
            'Desain Grafis KIB',
            'Mobile Programming',
          ]),
          buildTabContent('TRIWULAN 4', [
            'Digital Marketing KIBD',
            'Content Creation',
            'Desain Sprint',
          ]),
        ],
      ),
    );
  }
}
