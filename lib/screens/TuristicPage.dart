import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sangeorzbai_turistic/screens/TuristicLocationPage.dart';

class TuristicPage extends StatefulWidget {
  final String turisticTitle;

  const TuristicPage({Key? key, required this.turisticTitle}) : super(key: key);

  @override
  State<TuristicPage> createState() => _TuristicPageState();
}

class _TuristicPageState extends State<TuristicPage> {
  List<Map> turisticLocatiiList = [
    {
      'title': 'Centrul Cultural Iustin Sohorca',
      'locationPointName': 'str. DN17D'
    },
    {
      'title': 'Muzeul de Artă Comparată',
      'locationPointName': 'str. Republicii, nr. 68'
    },
    {'title': 'Ansamblul Monumental „Ferestre”', 'locationPointName': 'DN17D'},
    {'title': 'Statuia „Veriga Nemărginită”', 'locationPointName': 'DN17D'},
    {
      'title': 'Centrul Misionar de Tineret „Ioan Bunea”',
      'locationPointName': 'DN17D'
    },
    {'title': 'Biserica „Sfântul Nicolae”', 'locationPointName': 'DN17D'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.turisticTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...turisticLocatiiList.map((location) => ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TuristicLocationPage(
                        locationTitle: location['title'],
                      ),
                    ),
                  );
                },
                title: Text(location['title']),
                subtitle: Text(location['locationPointName']),
              ))
        ],
      ),
    );
  }
}
