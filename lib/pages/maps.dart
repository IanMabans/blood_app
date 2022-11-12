import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class hospitalMaps extends StatefulWidget {
  const hospitalMaps({Key? key}) : super(key: key);

  @override
  State<hospitalMaps> createState() => _hospitalMapsState();
}

class _hospitalMapsState extends State<hospitalMaps> {
  late GoogleMapController googleMapController;
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(-1.1772739, 36.9218576), zoom: 11.5);
  Set<Marker> markers = {};

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    polylinePoints = PolylinePoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Location'),
      ),
      body: Stack(children: <Widget>[
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          polylines: _polylines,
          markers: markers,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
            setPolylines();
          },
        ),
        Container(
          padding: const EdgeInsets.only(top: 24, right: 12),
          alignment: Alignment.topRight,
          child: Column(
            children: <Widget>[
              FloatingActionButton.extended(
                onPressed: () async {
                  googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(-1.2737, 36.8993), zoom: 14)));

                  markers.add(Marker(
                      markerId: const MarkerId('hospitalLocation'),
                      position: LatLng(-1.2737, 36.8993)));

                  setState(() {});
                },
                label: const Text("Hospital Location"),
                icon: const Icon(Icons.local_hospital),
                backgroundColor: Colors.blueAccent,
              ),
              const SizedBox(height: 20.0,),
              FloatingActionButton.extended(
                onPressed: () async {
                  Position position = await _determinePosition();

                  googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 14)));

                  markers.add(Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: LatLng(position.latitude, position.longitude)));

                  setState(() {});
                },
                label: const Text("Current Location"),
                icon: const Icon(Icons.location_history),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');

    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  void setPolylines() async {
    Position position = await _determinePosition();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyCtY_RyDV51VtYg5mvJOb6u2SsnVu1iyx4',
        PointLatLng(position.latitude, position.longitude),
        PointLatLng(-1.2737, 36.8993));
    if (result.status =='OK'){
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(
            Polyline(
              width: 3,
              polylineId: PolylineId('polyline'),
              color: Colors.lightBlueAccent,
                points: polylineCoordinates
            ));
      });
    }
  }
}
