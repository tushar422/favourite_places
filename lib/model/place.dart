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
    id,
    required this.title,
    required this.image,
    required this.location,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File? image;
  final PlaceLocation location;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image?.path ?? '',
      'lat': location.lat,
      'lng': location.lng,
      'address': location.address,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'],
      title: map['title'],
      image: (map['image'] != '') ? File(map['image']) : null,
      location: PlaceLocation(
        lat: map['lat'],
        lng: map['lng'],
        address: map['address'],
      ),
    );
  }
}
