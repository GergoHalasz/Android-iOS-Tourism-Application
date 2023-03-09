import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sangeorzbai_turistic/utils/map_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TuristicLocationPage extends StatefulWidget {
  final String locationTitle;
  final List data;

  const TuristicLocationPage(
      {Key? key, required this.locationTitle, required this.data})
      : super(key: key);

  @override
  State<TuristicLocationPage> createState() => _TuristicLocationPageState();
}

class _TuristicLocationPageState extends State<TuristicLocationPage> {
  var pageData = null;
  bool isFavourite = false;

  fetchPageData() async {
    for (var page in widget.data) {
      if (page["title"]["rendered"] == widget.locationTitle) {
        setState(() {
          pageData = page;
        });
      }
    }
  }

  @override
  void initState() {
    fetchPageData();
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      final bool isFavourite =
          prefs.getString(pageData["title"]["rendered"]) == null ? false : true;

      setState(() {
        this.isFavourite = isFavourite;
      });
    });
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
            actions: [
              IconButton(
                  onPressed: () async {
                    setState(() {
                      isFavourite = !isFavourite;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    if (isFavourite) {
                      prefs.setString(pageData["title"]["rendered"],
                         "isFavouritedLocation");
                    } else {
                      prefs.remove(pageData["title"]["rendered"]);
                    }
                  },
                  icon: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: Color.fromARGB(203, 255, 1, 1),
                  ))
            ],
            centerTitle: true,
            title: Image(
              image: AssetImage('images/websiteIcon.png'),
              width: 130,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 15),
                        child: Center(
                            child: Text(
                          widget.locationTitle,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                      ),
                      if (pageData['yoast_head_json']['og_image'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                              key: UniqueKey(),
                              placeholder: (context, url) => Container(
                                    height: 250,
                                    color: Colors.black12,
                                  ),
                              imageUrl: pageData['yoast_head_json']['og_image']
                                  [0]["url"]),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Html(
                        style: {
                          "p": Style(
                            lineHeight: LineHeight.number(1.3),
                          )
                        },
                        data: pageData['content']['rendered'],
                        onLinkTap: (String? url, RenderContext context,
                            Map<String, String> attributes, element) {
                          if (url != null) launchUrl(Uri.parse(url));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (pageData['googleMapsLink'] != "")
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: ElevatedButton(
                              onPressed: () async {
                                if (Platform.isAndroid)
                                  MapUtils.openMap(pageData['googleMapsLink']);
                                else {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  String? mapType = prefs.getString('mapType');
                                  if (mapType == null) {
                                    showCupertinoDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                              title: Text('Alegeti aplicatia care va afisa locatia.'),
                                              actions: [
                                                CupertinoDialogAction(
                                                    child: Text('Google Maps'),
                                                    onPressed: () {
                                                      prefs.setString(
                                                          'mapType', 'google');
                                                      MapUtils.openMap(pageData[
                                                          'googleMapsLink']);
                                                      Navigator.pop(context);
                                                    }),
                                                CupertinoDialogAction(
                                                    child: Text('Apple Maps'),
                                                    onPressed: () {
                                                      prefs.setString(
                                                          'mapType', 'apple');
                                                      MapUtils.openMap(pageData[
                                                          'appleMapsLink']);
                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            ));
                                  } else {
                                    if (mapType == 'google') {
                                      MapUtils.openMap(
                                          pageData['googleMapsLink']);
                                    } else {
                                      MapUtils.openMap(
                                          pageData['appleMapsLink']);
                                    }
                                  }
                                }
                              },
                              child: Text('Vezi pe Hartă')),
                        )
                    ],
                  )),
            ),
          )),
    );
  }
}
