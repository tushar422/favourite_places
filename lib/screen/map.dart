import 'package:favourite_places/model/place.dart';
import 'package:favourite_places/util/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location,
  });

  final PlaceLocation? location;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PlaceLocation? _location;
  double _lat = 0;
  double _lng = 0;

  @override
  void initState() {
    if (widget.location == null) {
      _initLocation();
    } else {
      setState(() {
        _location = widget.location;
        _lat = _location!.lat;
        _lng = _location!.lng;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (widget.location == null)
          ? FloatingActionButton(
              onPressed: _saveLocation,
              child: const Icon(Icons.done),
            )
          : null,
      body: (_location == null)
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please wait while the map is loading.',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 10),
                    const LinearProgressIndicator(),
                  ],
                ),
              ),
            )
          : GoogleMap(
              zoomControlsEnabled: false,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _location!.lat,
                  _location!.lng,
                ),
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('self'),
                  position: LatLng(
                    _lat,
                    _lng,
                  ),
                ),
              },
              onTap: (widget.location == null)
                  ? (pos) {
                      setState(() {
                        _lat = pos.latitude;
                        _lng = pos.longitude;
                      });
                    }
                  : null,
            ),
    );
  }

  void _saveLocation() async {
    final location = PlaceLocation(
      lat: _lat,
      lng: _lng,
      address: await getAddress(_lat, _lng),
    );
    Navigator.pop(context, location);
  }

  void _initLocation() async {
    final location = await getCurrentLocation();
    setState(() {
      _location = location;
    });
  }
}
