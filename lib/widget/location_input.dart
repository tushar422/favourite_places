import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:favourite_places/auth/secrets.dart';
import 'package:favourite_places/model/place.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelect});

  @override
  State<LocationInput> createState() => _LocationInputState();
  final void Function(PlaceLocation? location) onSelect;
}

class _LocationInputState extends State<LocationInput> {
  bool _isFetchingLocation = false;
  PlaceLocation? _selectedLocation;

  String get locationImage {
    final lat = _selectedLocation!.lat;
    final lng = _selectedLocation!.lng;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng'
        '&zoom=14&size=600x300&maptype=roadmap'
        '&markers=color:red%7C$lat,$lng&key=$mapsApiKey';
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_isFetchingLocation) {
      content = const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: LinearProgressIndicator(),
        ),
      );
    } else {
      if (_selectedLocation != null) {
        content = Image.network(
          _selectedLocation!.locationImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } else {
        content = Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text('Add Current Location'),
              onPressed: _selectLocation,
            ),
            const SizedBox(),
            TextButton.icon(
              icon: const Icon(Icons.pin_drop),
              label: const Text('Add Custom Location'),
              onPressed: () {},
            ),
          ],
        ));
      }
    }

    return DottedBorder(
      dashPattern: const [7, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(20),
      color: Theme.of(context).colorScheme.onBackground,
      child: Container(
        height: 250,
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: content,
      ),
    );
  }

  void _selectLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) return;
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.longitude}&key=$mapsApiKey');
    final response = await http.get(url);
    final data = json.decode(response.body);
    final address = data['results'][0]['formatted_address'];

    final placeLocation = PlaceLocation(
      lat: locationData.latitude!,
      lng: locationData.longitude!,
      address: address,
    );
    setState(() {
      _selectedLocation = placeLocation;
      _isFetchingLocation = false;
    });
    widget.onSelect(_selectedLocation);
    // print(' ');
  }
}
