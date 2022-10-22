import 'package:flutter/material.dart';
import 'package:sangeorzbai_turistic/screens/TuristicPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sangeorzbai Turistic App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> turisticList = [
    'Obiective culturale',
    'Obiective de alimentație publică',
    'Obiective de primire turistică (cazare)',
    'Obiective turistice',
    'Puncte de interes'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...turisticList
              .map((turistic) => ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TuristicPage(turisticTitle: turistic),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.location_on,
                      color: Color(0xff17669a),
                    ),
                    title: Text(turistic),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
