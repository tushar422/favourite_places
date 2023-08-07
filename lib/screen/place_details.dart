import 'package:favourite_places/model/place.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key, required this.place});

  final Place place;

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Widget? background = (widget.place.image != null)
        ? Image.file(
            widget.place.image!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.blueAccent,
                ],
              ),
            ),
          );
    return Scaffold(
      appBar: AppBar(title: Text(widget.place.title)),
      body: Stack(
        children: [
          background,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      widget.place.location.locationImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        color: Color.fromARGB(187, 255, 255, 255),
                      ),
                      child: Text(
                        widget.place.location.address,
                        softWrap: true,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
