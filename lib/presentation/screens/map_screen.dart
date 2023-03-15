import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_app/business_logic/cubit/auth_cubit/phone_auth_cubit.dart';
import 'package:location_app/constance/my_color.dart';
import 'package:location_app/helpers/location_helper.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../widgets/my_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static Position? position;

  FloatingSearchBarController controller = FloatingSearchBarController();
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

  Widget buildFloatingSearchBar()
  {
    final isPortrait  = MediaQuery.of(context).orientation == Orientation.portrait ;
    return FloatingSearchBar(
        builder:(context,transition)
        {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children:const [],
            ),
          );
        },
      controller:controller ,
      elevation: 0.0,
      hintStyle:const TextStyle(fontSize: 18.0),
      queryStyle:const TextStyle(fontSize: 18),
      borderRadius: BorderRadius.circular(16),
      hint: 'Find a place..',
      border:const BorderSide(
        style: BorderStyle.solid,
        color: Colors.white,
      ),
      margins:const EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding:const EdgeInsets.fromLTRB(8, 0, 2, 0),
      height: 60.0,
       iconColor: MyColor.blue,
      scrollPadding: const EdgeInsets.only(top: 16,bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query){},
      onFocusChanged: (_){},
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(icon:const Icon(Icons.place,), onPressed: (){}),
        ),
      ],

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
      drawer: MyDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null
              ? buildMap()
              : const Center(
                child: CircularProgressIndicator(
                  color: MyColor.blue,
                ),
              ),
          buildFloatingSearchBar(),
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
