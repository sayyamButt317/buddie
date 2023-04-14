import 'dart:async';
import 'dart:ui' as ui;
import 'package:firebase_database/firebase_database.dart';
import 'package:buddie/Views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'chatmessage.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

final auth = FirebaseAuth.instance;
const kGoogleApiKey = "AIzaSyAIPpmkgUm8g34XrGApJ4_00XLaynPV43Q";
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  // Initialize the database reference

  late GoogleMapController googleMapController;
  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  final Mode _mode = Mode.overlay;
  bool showSourceField = false;
  Position? currentPosition;
  final Set<Polyline> _polyline = {};
  late LatLng destination;
  late LatLng source;
  late Uint8List markIcons;
  Set<Marker> markers = {};

  final now = DateTime.now();

  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    loadCustomMarker();
    _findNearestUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white, // set appbar background color to green
        title: IconButton(
          onPressed: () {
            auth.signOut().then((value) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            }).onError((error, stackTrace) {
              Get.snackbar("Error", error.toString());
            });
          },
          icon: const Icon(Icons.logout),
        ),
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: markers,
            polylines: _polyline,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          buildCurrentLocationIcon(),
          buildCupertinoTextFieldForDestination(),
          buildSearchPeopleIcon(),
          showSourceField ? buildCupertinoTextFieldForSource() : Container(),
        ],
      ),
    );
  }

  Widget buildSearchPeopleIcon() {
    return Positioned(
      bottom: 100,
      right: 10,
      child: FloatingActionButton(
        onPressed: _findNearestUsers,
        backgroundColor: Colors.white,
        child: const Icon(Icons.person, color: Colors.green),
      ),
    );
  }

  List<User> userList = [];

  void _findNearestUsers() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng userLocation1 =
        LatLng(position.latitude + 0.0045, position.longitude + 0.0045);
    User dummyUser1 = User(
        id: 1,
        name: 'Ali',
        email: 'Ali@example.com',
        ethnicity: 'Asian',
        major: 'Computer Science',
        age: '25yrs',
        imagePath: 'images/man.png',
        latitude: userLocation1.latitude,
        longitude: userLocation1.longitude);

    LatLng userLocation2 =
        LatLng(position.latitude + 0.0055, position.longitude + 0.0055);
    User dummyUser2 = User(
        id: 2,
        name: 'Bob',
        email: 'Bob@example.com',
        ethnicity: 'Hispanic & Caucasian',
        major: 'Graphic Designer',
        age: '35',
        imagePath: 'images/man.png',
        latitude: userLocation2.latitude,
        longitude: userLocation2.longitude);

    LatLng userLocation3 =
        LatLng(position.latitude + 0.0025, position.longitude + 0.0025);
    User dummyUser3 = User(
        id: 3,
        name: 'Sam',
        email: 'Sam@example.com',
        ethnicity: 'British',
        major: 'Graphic Designer',
        age: '20',
        imagePath: 'images/man.png',
        latitude: userLocation3.latitude,
        longitude: userLocation3.longitude);

    final marker = [dummyUser1, dummyUser2, dummyUser3]
        .map((user) async => Marker(
              markerId: MarkerId(user.id.toString()),
              position: LatLng(user.latitude, user.longitude),
              icon: BitmapDescriptor.fromBytes(markIcons),
              infoWindow: InfoWindow(
                title: user.name,
                snippet: '${user.ethnicity}, ${user.major},${user.age}',
              ),
              onTap: () async {
                // Launch a ChatRoomScreen with the selected user
                bool isChatLaunched = await launchChatWithUser(user);

                if (isChatLaunched) {
                  // Chat was launched successfully, do something
                } else {
                  // Chat failed to launch, do something else
                }
              },
            ))
        .toList();

    final markersToAdd = await Future.wait(marker);

    markers.clear();
    setState(() {
      userList.addAll([dummyUser1, dummyUser2, dummyUser3]);
      markers.addAll(markersToAdd);
    });
  }

  Future<bool> launchChatWithUser(User user) {
    return Get.to(() => ChatScreen(
              currentUserId: 'currentUserId',
              otherUserId: user.id.toString(),
            ))!
        .then((result) {
      // Chat box was launched successfully
      return true;
    }).catchError((error) {
      // Chat box failed to launch
      debugPrint(error);
      return false;
    });
  }

  buildCurrentLocationIcon() {
    return Positioned(
      bottom: 20,
      right: 55,
      child: FloatingActionButton(
        onPressed: () async {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          LatLng latLng = LatLng(position.latitude, position.longitude);
          googleMapController.animateCamera(CameraUpdate.newLatLng(latLng));

          // Update current location marker
          final currentLocationMarker = markers.firstWhere(
            (marker) => marker.markerId == const MarkerId('current_location'),
            orElse: () => Marker(
              markerId: const MarkerId('current_location'),
              position: latLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
              infoWindow: const InfoWindow(
                title: 'Current Location',
                snippet: 'Your current location',
              ),
            ),
          );
          setState(() {
            markers.remove(currentLocationMarker);
            markers.add(currentLocationMarker.copyWith(positionParam: latLng));
          });
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.green),
      ),
    );
  }

  Widget buildCupertinoTextFieldForDestination() {
    return Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(0),
        ),
        child: TextFormField(
          controller: destinationController,
          readOnly: true,
          onTap: () async {
            String selectedPlace = await showGoogleAutoComplete();
            destinationController.text = selectedPlace;
            List<geoCoding.Location> locations =
                await geoCoding.locationFromAddress(selectedPlace);
            destination =
                LatLng(locations.first.latitude, locations.first.longitude);
            markers.removeWhere(
              (marker) => marker.markerId == const MarkerId('destination'),
            );
            markers.add(
              Marker(
                markerId: const MarkerId('destination'),
                position: destination,
                icon: BitmapDescriptor.fromBytes(markIcons),
                infoWindow: InfoWindow(
                  title: 'Destination: $selectedPlace',
                ),
              ),
            );

            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: destination, zoom: 14),
              ),
            );
            setState(() {
              showSourceField = true;
            });
          },
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xffA7A7A7),
          ),
          decoration: InputDecoration(
            hintText: 'Enter Your Destination',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xffA7A7A7),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildCupertinoTextFieldForSource() {
    return Positioned(
      top: 95,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(0),
        ),
        child: TextFormField(
          controller: sourceController,
          decoration: const InputDecoration(
            hintText: 'Enter source location',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                showSourceField = true;
              });
            } else {
              setState(() {
                showSourceField = false;
              });
            }
          },
          onTap: () async {
            String place = await showGoogleAutoComplete();
            sourceController.text = place;
            List<geoCoding.Location> locations =
                await geoCoding.locationFromAddress(place);
            source =
                LatLng(locations.first.latitude, locations.first.longitude);
            if (markers.length >= 2) {
              markers.remove(markers.last);
            }

            markers.add(
              Marker(
                markerId: const MarkerId('source'),
                position: source,
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(
                  title: 'Starting Point: $place',
                ),
              ),
            );
            drawPolyline(place);

            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: source, zoom: 14),
              ),
            );
            setState(() {});
          },
        ),
      ),
    );
  }

  void drawPolyline(String placeId) {
    _polyline.clear();
    _polyline.add(Polyline(
      polylineId: PolylineId(placeId),
      visible: true,
      points: [source, destination],
      color: Colors.green,
      width: 5,
    ));
  }

  //Custom marker
  loadCustomMarker() async {
    markIcons = await loadAsset('images/placeholder.png', 100);
  }

  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<String> showGoogleAutoComplete() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: _mode,
      language: 'en',
      onError: onError,
      strictbounds: false,
      types: [""],
      components: [
        Component(Component.country, "pk"),
        Component(Component.country, "usa")
      ],
    );

    return p?.description ?? '';
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p.placeId ?? '');

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name),
      ),
    );

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String ethnicity;
  final String major;
  final String age;
  final String imagePath;
  final double latitude;
  final double longitude;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.ethnicity,
    required this.major,
    required this.age,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
  });
}
