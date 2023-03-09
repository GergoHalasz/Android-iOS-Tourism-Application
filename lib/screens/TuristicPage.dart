import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sangeorzbai_turistic/screens/TuristicLocationPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TuristicPage extends StatefulWidget {
  final String turisticTitle;
  final int turisticId;
  final List data;

  const TuristicPage(
      {Key? key,
      required this.turisticTitle,
      required this.turisticId,
      required this.data})
      : super(key: key);

  @override
  State<TuristicPage> createState() => _TuristicPageState();
}

class _TuristicPageState extends State<TuristicPage> {
  List<Map> turisticLocatiiList = [];
  var content = "";

  fetchPageData() async {
    int pageId = widget.turisticId;
    List<Map> list = [];
    for (var page in widget.data) {
      if (page["parent"] == pageId) {
        list.add({
          "title": page["title"]["rendered"],
          "locationPointName": "DN171",
          "id": page["id"]
        });
        print(page['title']['rendered']);
      }
      setState(() {
        turisticLocatiiList.sort(((a, b) {
          return a["title"].compareTo(b["title"]);
        }));
        turisticLocatiiList = list;
      });
    }
  }

  @override
  void initState() {
    fetchPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        bottomNavigationBar: Container(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image(
                image: AssetImage('images/logos_aplicatie.png'),
              ),
            ),
          ),
        appBar: AppBar(
          centerTitle: true,
          title: Image(
            image: AssetImage('images/websiteIcon.png'),
            width: 130,
          ),
        ),
        body: DefaultTextStyle(
          style: TextStyle(fontFamily: "OpenSans", fontSize: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    children: [
                      ...turisticLocatiiList.map((location) => Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TuristicLocationPage(
                                        locationTitle: location['title'],
                                        data: widget.data,
                                      ),
                                    ),
                                  );
                                },
                                leading: Icon(Icons.location_on),
                                title: Text(location['title']),
                                minLeadingWidth : 16,
                              ),
                              Divider(
                                height: 0.1,
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
