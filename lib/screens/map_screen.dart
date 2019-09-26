import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import '../models/place.dart';

class MapsScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapsScreen(
      {this.initialLocation = const PlaceLocation(latitude: 0.0, longitude: 0.0),
      this.isSelecting = false});

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng _selectedLocation;

  void _pickedLocation(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
      ),
      body: GoogleMap(
        markers: _selectedLocation == null && widget.isSelecting
            ? null
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _selectedLocation ??
                      LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude),
                ),
              },
        onTap: widget.isSelecting ? (pos) => _pickedLocation(pos) : null,
        initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.initialLocation.latitude,
              widget.initialLocation.longitude,
            ),
            zoom: 16),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (widget.isSelecting && _selectedLocation != null)
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(_selectedLocation),
              child: Icon(Icons.check),
            )
          : null,
    );
  }
}
