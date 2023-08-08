import 'dart:convert';

import 'package:favourite_places/auth/secrets.dart';
import 'package:favourite_places/model/place.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

Future<PlaceLocation> getCurrentLocation() async {
  const defaultLocation = PlaceLocation(lat: 0, lng: 0, address: 'ERROR');
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return defaultLocation;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return defaultLocation;
    }
  }

  locationData = await location.getLocation();

  if (locationData.latitude == null || locationData.longitude == null)
    return defaultLocation;
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.longitude}&key=$mapsApiKey');
  final response = await http.get(url);
  final data = json.decode(response.body);
  final address = data['results'][0]['formatted_address'];
  return PlaceLocation(
    lat: locationData.latitude!,
    lng: locationData.longitude!,
    address: address,
  );
}

Future<String> getAddress(double lat, double lng) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$mapsApiKey');
  final response = await http.get(url);
  final data = json.decode(response.body);
  return data['results'][0]['formatted_address'];
}
