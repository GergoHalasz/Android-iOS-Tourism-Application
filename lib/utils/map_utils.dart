import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleMapUrl = 'https://www.google.com/maps/dir/?api=1&origin=Space+Needle+Seattle+WA&destination=Pike+Place+Market+Seattle+WA&travelmode=bicycling';
    Uri uri = Uri.parse(googleMapUrl);

    launchUrl(uri,mode: LaunchMode.externalApplication);
  }
}