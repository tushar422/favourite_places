import 'dart:io';

import 'package:uuid/uuid.dart';

import '../auth/secrets.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.lat,
    required this.lng,
    required this.address,
  });

  final double lat;
  final double lng;
  final String address;
  String get locationImage {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng'
        '&zoom=14&size=600x300&maptype=roadmap'
        '&markers=color:red%7C$lat,$lng&key=$mapsApiKey';
  }
}

class Place {
  Place({
    required this.title,
    required this.image,
    required this.location,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final File? image;
  final PlaceLocation location;
}
