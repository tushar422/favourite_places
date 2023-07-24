import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelect});

  @override
  State<LocationInput> createState() => _LocationInputState();
  final void Function(File? image) onSelect;
}

class _LocationInputState extends State<LocationInput> {
  bool _isFetchingLocation = false;
  Location? _selectedLocation;

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
    setState(() {
      _isFetchingLocation = false;
    });
    print('${locationData.latitude} ${locationData.longitude}');
  }
}
