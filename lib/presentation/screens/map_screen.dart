import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_app/business_logic/cubit/auth_cubit/phone_auth_cubit.dart';
import 'package:location_app/constance/my_color.dart';
import 'package:location_app/helpers/location_helper.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static Position? position;

  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(
      position!.latitude,
      position!.longitude,
    ),
    tilt: 0,
    zoom: 17,
  );

  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  Future<void> getMyCurrentLocation() async {
    await LocationHelper.determineCurrentLocation();

    position = await Geolocator.getLastKnownPosition().whenComplete(() {
      setState(() {});
    });
  }

  Widget buildMap() {
    return GoogleMap(
      initialCameraPosition: _myCurrentLocationCameraPosition,
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  @override
  void initState() {
    getMyCurrentLocation();
    super.initState();
  }

    Future<void> _goToMyCurrentLocation () async
    {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          position != null
              ? buildMap()
              : const Center(
                child: CircularProgressIndicator(
                  color: MyColor.blue,
                ),
              ),
        ],
      ),
      floatingActionButton: Container(
        margin:const EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          backgroundColor: MyColor.blue,
          onPressed: _goToMyCurrentLocation,
          child:const Icon(Icons.place,color: Colors.white,),
        ),
      ),
    );
  }
}
