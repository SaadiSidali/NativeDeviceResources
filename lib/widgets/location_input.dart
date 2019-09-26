import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectLocation;
  LocationInput(this.onSelectLocation);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;


  void _updatePreview(double lat,double lng)
  {
    final staticMapUrl = LocationHelper.generateLocationPreviewImage(
      lat: lat,
      long: lng,
    );
    setState(() {
      _previewImageUrl = staticMapUrl;
    });
  }

  Future<void> _fetchUserLocation() async {
    final locationData = await Location().getLocation();
    _updatePreview(locationData.latitude, locationData.longitude);
    widget.onSelectLocation(locationData.latitude,locationData.longitude);
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => MapsScreen(isSelecting: true,),
    ));
    if (selectedLocation == null) return;
    _updatePreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectLocation(selectedLocation.latitude,selectedLocation.longitude);
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.deepPurple)),
          height: 200,
          width: double.infinity,
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? Text(
                  'No Location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              onPressed: _fetchUserLocation,
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
                icon: Icon(Icons.map),
                label: Text('Select on Map'),
                onPressed: _selectOnMap,
                textColor: Theme.of(context).primaryColor)
          ],
        )
      ],
    );
  }
}
