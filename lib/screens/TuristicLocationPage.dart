import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sangeorzbai_turistic/utils/map_utils.dart';
import 'package:http/http.dart' as http;

class TuristicLocationPage extends StatefulWidget {
  final String locationTitle;
  const TuristicLocationPage({Key? key, required this.locationTitle})
      : super(key: key);

  @override
  State<TuristicLocationPage> createState() => _TuristicLocationPageState();
}

class _TuristicLocationPageState extends State<TuristicLocationPage> {
  Future fetchAlbum() {
    return http
        .get(Uri.parse('https://sangeorzbai.ro/wp-json/wp/v2/pages?page=4'));
  }

  @override
  Widget build(BuildContext context) {
    fetchAlbum().then((value) => print(value.body));
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.locationTitle),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                      'https://sangeorzbai.ro/wp-content/uploads/2021/06/IMG_1135-1170x780.jpg'),
                  SizedBox(height: 15),
                  Text(
                      'Este din punct de vedere juridic, secție a Complexului Muzeal Bistrița-Năsăud, clasificat ca fiind instituție de importanță județeană.'),
                  SizedBox(height: 15),
                  Text(
                      'Colecția de bază o constituie lucrările de artă contemporană – sculptură (lemn, marmură, metal), dar și elemente de pictură, fotografie, grafică, ceramică, porțelan și altele, ale 135 de artiști invitați la toate edițiile Simpozionului de Artă Contemporană „ART”. Piesele etnografice existente permit vizitatorilor comunicarea între trecut și prezent. Scopul declarat al muzeului este de a surprinde și transmite spiritualitatea zonei prin artă, refuzând să accepte ideea de muzeu ca spațiu – adăpost pentru bunuri mobile ce aparțin trecutului. Desfășurarea Muzeului nu oferă decât repere, nu informație gata prelucrată, astfel că produsul finit este în sine un produs artistic.'),
                  SizedBox(height: 15),
                  Text(
                      'Deși este un muzeu mic, instituția se dorește a fi un centru de informare în arta plastică contemporană, astfel că sunt puse la dispoziția publicului o arhivă audiovizuală conținând fotografii, clișee, filme foto, casete audio și video, CD-uri, în majoritate având legătură cu Simpozioanele organizate și o bibliotecă formată în special din albume de artă. Organizat în forma actuală pe parcursul anului 2006. Muzeul a fost inaugurat în data de 5 mai 2007.'),
                  SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () {
                        MapUtils.openMap(47.2, -122.342);
                      },
                      child: Text('Vezi pe Hartă'))
                ],
              ),
            ),
          ),
        ));
  }
}
