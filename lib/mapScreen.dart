import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition cameraPosition;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
    );

  void updateMarker(CameraPosition position){
    final MarkerId markerId = MarkerId("selectedLocation");
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(position.target.latitude, position.target.longitude),
      onTap: (){
        print("Location selected");
      }
    );

    markers[markerId] = marker;
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        title: Text('The Google Maps Tutorial'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        onCameraMove: (position){
          //debugPrint("Camera Position Ghulam Mustafa $position ");
          setState(() {
            cameraPosition = position;
          });
          updateMarker(cameraPosition);
        },
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.pop(context, cameraPosition);
        },
        label: Text('Location confirmed!'),
      ),
    );
  }
}
