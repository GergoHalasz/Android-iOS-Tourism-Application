import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TuristicLocationPage.dart';

class FavouritesPage extends StatefulWidget {
  final List data;
  const FavouritesPage({super.key, required this.data});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<String> favouritesList = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().toList();

      final finalFav = keys.where((key) {
        return prefs.get(key) == "isFavouritedLocation";
      }).toList();
      setState(() {
        favouritesList = finalFav;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Favorite'),
          ),
          body: ListView(children: [
            ...favouritesList.map((favourite) {
              return Column(children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TuristicLocationPage(
                          locationTitle: favourite,
                          data: widget.data,
                        ),
                      ),
                    );
                  },
                  title: Text(favourite),
                ),
                Divider(
                  height: 0.1,
                ),
              ]);
            }).toList(),
          ])),
    );
  }
}
