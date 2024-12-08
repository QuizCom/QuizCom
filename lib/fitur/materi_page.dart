import 'package:flutter/material.dart';
import 'package:myapp/fitur/mulai_page.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MateriPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedValue = 'Q1';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            'Aplikasi Teknologi Informasi dan SOHO Networking'
          ]),
          buildTabContent('TRIWULAN 2', [
            'UI UX Design',
            'Aplikasi Web CMS',
            'Web Programming'
          ]),
          buildTabContent('TRIWULAN 3', [
            'Desain Grafis KIB',
            'Mobile Programming'
          ]),
          buildTabContent('TRIWULAN 4', [
            'Digital Marketing KIBD',
            'Content Creation',
            'Desain Sprint'
          ]),
        ],
      ),
    );
  }

  Widget buildTabContent(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                String item = items[index];
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(item),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<String>(
                            value: selectedValue,
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'Q1',
                                child: Text('Q1'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Q2',
                                child: Text('Q2'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'FINAL',
                                child: Text('FINAL'),
                              ),
                            ],
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedValue = newValue;
                                });

                                if (newValue == 'Q1') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Q1Page(
                                        namaMateri: item,
                                      ),
                                    ),
                                  );
                                } else if (newValue == 'Q2') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Q2Page(
                                        namaMateri: item,
                                      ),
                                    ),
                                  );
                                } else if (newValue == 'FINAL') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FinalPage(
                                        namaMateri: item,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
