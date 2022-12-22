import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sangeorzbai_turistic/screens/FavouritesPage.dart';
import 'package:sangeorzbai_turistic/screens/TuristicLocationPage.dart';
import 'package:sangeorzbai_turistic/screens/TuristicPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:diacritic/diacritic.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  List datas = [];
  bool result = await InternetConnectionChecker().hasConnection;
  if (result == true) {
    await Future.wait([initialization(), Future.delayed(Duration(seconds: 2))])
        .then((values) => datas = values[0]);

    datas = datas.map((data) {
      if (data['title']['rendered'] == "Haus Park Pub &#038; Bistro") {
        data['title']['rendered'] = "Haus Park Pub & Bistro";
      } else if (data['title']['rendered'] ==
          "El&#038;Ea magazin de îmbrăcăminte") {
        data['title']['rendered'] = "El&Ea magazin de îmbrăcăminte";
      } else if (data['title']['rendered'] == "RCS&#038;RDS") {
        data['title']['rendered'] = "RCS&RDS";
      }
      return data;
    }).toList();
  }

  FlutterNativeSplash.remove();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp(
      data: datas,
    ));
  });
}

Future initialization() async {
  var allData = await http.get(
      Uri.parse('https://sangeorzbai.ro/wp-json/wp/v2/pages?per_page=100'));
  return jsonDecode(allData.body);
}

class MyApp extends StatelessWidget {
  final List data;
  const MyApp({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(data);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Sangeorzbai Turistic App',
        data: data,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List data;
  const MyHomePage({Key? key, required this.title, required this.data})
      : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Image image1 = Image.asset('images/asd1.jpg', fit: BoxFit.cover);
  Image image2 = Image.asset('images/asd2.jpg', fit: BoxFit.cover);
  Image image3 = Image.asset('images/asd3.jpg', fit: BoxFit.cover);
  Image image4 = Image.asset('images/asd4.jpg', fit: BoxFit.cover);
  Image image5 = Image.asset('images/asd5.jpg', fit: BoxFit.cover);
  Image image6 = Image.asset('images/asd6.jpg', fit: BoxFit.cover);

  List<Image> imagesWithNames = [];
  int scrollIndex = 0;
  List<Map> turisticList = [
    {
      "title": 'Obiective culturale',
      "id": 2328,
      "icon": Icon(
        Icons.museum,
      ),
    },
    {
      "title": 'Obiective de alimentație publică',
      "id": 2326,
      "icon": Icon(
        Icons.restaurant,
      ),
    },
    {
      "title": 'Obiective de primire turistică (cazare)',
      "id": 2323,
      "icon": Icon(
        Icons.home,
      ),
    },
    {
      "title": 'Obiective turistice',
      "id": 2321,
      "icon": Icon(
        Icons.map,
      ),
    },
    {
      "title": 'Puncte de interes',
      "id": 2506,
      "icon": Icon(
        Icons.home_work,
      ),
    }
  ];

  Future<void> _launchUrl(type) async {
    final Uri _url = Uri.parse(type == 'contact'
        ? 'https://sangeorzbai.ro/contact/'
        : 'https://sangeorzbai.ro/articole/noutati/evenimente/');
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool result = await InternetConnectionChecker().hasConnection;
      if (!result) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Eroare'),
                content: Text(
                    'Nu există conexiune la internet. Este necesară conexiunea la internet pentru a putea accesa aplicația.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Închide'))
                ],
              );
            });
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    imagesWithNames = [image1, image2, image3, image4, image5, image6];
    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
    precacheImage(image4.image, context);
    precacheImage(image5.image, context);
    precacheImage(image6.image, context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: MySearchDelegate(widget.data));
                  },
                  icon: Icon(Icons.search)),
            ],
            centerTitle: true,
            title: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage('images/websiteIcon.png'),
                    width: 130,
                  ),
                  Image(
                    image: AssetImage('images/logo-sangeorzbai.png'),
                    width: 50,
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 200,
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Image(image: AssetImage('images/websiteIcon.png')),
                    ),
                  ),
                  ...turisticList
                      .map((turistic) => Column(
                            children: [
                              ListTile(
                                visualDensity: VisualDensity(vertical: -2),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TuristicPage(
                                          turisticTitle: turistic["title"],
                                          turisticId: turistic['id'],
                                          data: widget.data),
                                    ),
                                  );
                                },
                                leading: turistic['icon'],
                                title: Text(turistic["title"]),
                              ),
                              Divider(
                                height: 1,
                                thickness: 0.7,
                              )
                            ],
                          ))
                      .toList(),
                  Expanded(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Divider(
                                height: 1,
                                thickness: 0.7,
                              ),
                              ListTile(
                                visualDensity: VisualDensity(vertical: -2),
                                title: Text('Favorite'),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FavouritesPage(
                                            data: widget.data,
                                          )),
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.favorite,
                                  ),
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 0.7,
                              ),
                              ListTile(
                                  visualDensity: VisualDensity(vertical: -2),
                                  title: Text('Evenimente'),
                                  onTap: () => _launchUrl('evenimente'),
                                  leading: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.event,
                                    ),
                                  ),
                                  trailing: Transform.rotate(
                                    angle: 30.65,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 20,
                                    ),
                                  )),
                              Divider(
                                height: 1,
                                thickness: 0.7,
                              ),
                              ListTile(
                                  visualDensity: VisualDensity(vertical: -2),
                                  title: Text('Contact'),
                                  onTap: () => _launchUrl('contact'),
                                  leading: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.contact_mail,
                                    ),
                                  ),
                                  trailing: Transform.rotate(
                                    angle: 30.65,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 20,
                                    ),
                                  )),
                              Divider(
                                height: 1,
                                thickness: 0.7,
                              ),
                            ],
                          ))),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ImageSlideshow(
                  /// Width of the [ImageSlideshow].
                  width: double.infinity,

                  /// Height of the [ImageSlideshow].
                  height: 230,

                  /// The page to show when first creating the [ImageSlideshow].
                  initialPage: 0,

                  /// The color to paint the indicator.
                  indicatorColor: Colors.blue,

                  /// The color to paint behind th indicator.
                  indicatorBackgroundColor: Colors.grey,

                  /// The widgets to display in the [ImageSlideshow].
                  /// Add the sample image file into the images folder
                  children: [
                    ...imagesWithNames.map((imageWithName) {
                      return imageWithName;
                    }).toList(),
                  ],

                  /// Called whenever the page in the center of the viewport changes.
                ),
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              style: TextStyle(fontWeight: FontWeight.bold),
                              text:
                                  'Pentru a vedea categoriile, apăsați iconița'),
                          WidgetSpan(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Icon(
                              Icons.menu,
                              size: 19,
                            ),
                          )),
                          TextSpan(
                              style: TextStyle(fontWeight: FontWeight.bold),
                              text:
                                  'din stângă sus si selectați categoria dorită.'),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Despre noi',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Sângeorz-Băi este un oraș cu drepturi depline de stațiune, aflat în județul Bistrița-Năsăud, situat la poalele munților Rodnei și înzestrat cu cele mai frumoase și încântătoare daruri de la natură, cu o poveste frumoasă despre exploatarea și valorificarea turistică, balneară si culturală a resurselor în trecut care încă se reflectă în viața de zi cu zi și care se luptă să înflorească cu fiecare primăvară care vine. O poveste care trebuie actualizată, armonizată și scrisă prin combinația perfectă, specifică locului, dintre aer-apă-natură.',
                    style: TextStyle(height: 1.8),
                  ),
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 12),
                    child: Row(
                      children: [
                        Text('Site-ul proiectului: '),
                        InkWell(
                          child: Text(
                            'www.sangeorzbai.ro',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () => launchUrl(
                              Uri.parse('https://www.sangeorzbai.ro')),
                        )
                      ],
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Row(
                      children: [
                        Text('Site-ul primăriei: '),
                        InkWell(
                          child: Text(
                            'www.sangeorz-bai.ro',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () => launchUrl(
                              Uri.parse('https://www.sangeorz-bai.ro')),
                        )
                      ],
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                )
              ],
            ),
          )),
    );
  }
}

extension DiacriticsAwareString on String {
  static const diacritics = 'ÂĂâăÎîȘșȚț';
  static const nonDiacritics = 'AAaaIiSsTt';

  String get withoutDiacriticalMarks => this.splitMapJoin('',
      onNonMatch: (char) => char.isNotEmpty && diacritics.contains(char)
          ? nonDiacritics[diacritics.indexOf(char)]
          : char);
}

class MySearchDelegate extends SearchDelegate {
  late List datas;
  late List searchResult;

  MySearchDelegate(datas) {
    this.datas = datas;
    searchResult = this.datas.where((data) {
      return data['parent'] == 2506 ||
          data['parent'] == 2321 ||
          data['parent'] == 2323 ||
          data['parent'] == 2326 ||
          data['parent'] == 2328;
    }).toList();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = ThemeData.dark();
    assert(theme != null);
    return theme;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(
      child: Text(
        query,
        style: TextStyle(fontSize: 64),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResult
        .where((searchResult) {
          final result =
              removeDiacritics(searchResult['title']['rendered'].toLowerCase());
          final input = removeDiacritics(query.toLowerCase());
          var keywords = null;
          if (searchResult['keywords'] != null)
            keywords = searchResult['keywords'].split(',');

          if (input.contains('cultura')) {
            return searchResult['parent'] == 2328;
          } else if (keywords != null && keywords.contains(input)) {
            return true;
          } else if (input.contains('traseu') ||
              input.contains('traseu turistic')) {
            return searchResult['parent'] == 2321;
          } else if (input.contains('cazare') || input.contains('pensiune')) {
            return searchResult['parent'] == 2323;
          }
          return result.contains(input);
        })
        .map((e) => e['title']['rendered'] as String)
        .toList();

    return Scrollbar(
      thumbVisibility: true,
      child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: ((context, index) {
            final suggestion = suggestions[index];

            return Column(
              children: [
                ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TuristicLocationPage(
                          locationTitle: suggestion,
                          data: datas,
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  height: 0.1,
                ),
              ],
            );
          })),
    );
  }
}
