import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(String link) async {
    String googleMapUrl = link;
    Uri uri = Uri.parse(googleMapUrl);

    launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
