import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import '../Views/login.dart';

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

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.ethnicity,
      required this.major,
      required this.age,
      required this.imagePath,
      required this.latitude,
      required this.longitude});
}

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

final auth = FirebaseAuth.instance;
const kGoogleApiKey = 'AIzaSyAIPpmkgUm8g34XrGApJ4_00XLaynPV43Q';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(37.42796, -122.08574), zoom: 14.0);

  Set<Marker> markersList = {};
  late GoogleMapController googleMapController;
  TextEditingController destinationController = TextEditingController();
  final Mode _mode = Mode.overlay;

  Position? currentPosition;
  LatLng? source;
  Polyline? polyline;
  late LatLng destination;
  final Set<Polyline> _polylines = {};

  bool showAvailable = true;
  bool filterApplied = false;
  List<User> userList = [];

  void _addDummyUser() async {
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
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(
                title: user.name,
                snippet: '${user.ethnicity}, ${user.major},${user.age}',
              ),
            ))
        .toList();

    final markers = await Future.wait(marker);
    setState(() {
      userList.addAll([dummyUser1, dummyUser2, dummyUser3]);
      markersList.addAll(markers);
    });
  }

  void _userMarker(List<User> users) async {
    for (var user in users) {
      final bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        'images/man.png',
      );

      final marker = Marker(
        markerId: MarkerId(user.id.toString()),
        position: LatLng(user.latitude, user.longitude),
        icon: bitmapDescriptor,
        infoWindow: InfoWindow(
          title: user.name,
          snippet: '${user.ethnicity}, ${user.major},${user.name}',
        ),
      );

      setState(() {
        markersList.add(marker);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _userMarker(userList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: Container(
          color: Colors.green,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Colors.green),
                      child: UserAccountsDrawerHeader(
                        accountName: ListTile(
                          leading: Icon(Icons.phone, color: Colors.white),
                          title: Text(
                            "+1(773)732-3001",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        accountEmail: ListTile(
                          leading: Icon(Icons.email, color: Colors.white),
                          title: Text(
                            "support@buddie-up.com",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(color: Colors.green),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text(
                        'History',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'About',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Contact',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white, // set appbar background color to green
        // remove back icon
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
            initialCameraPosition: initialCameraPosition,
            markers: markersList,
            mapType: MapType.normal,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
              _userMarker(userList);
            },
          ),
          buildCupertinoTextField(),
          buildCurrentLocationIcon(),
          if (polyline != null) buildCurrentLocationIcon(),
        ],
      ),
    );
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
          final currentLocationMarker = markersList.firstWhere(
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
            markersList.remove(currentLocationMarker);
            markersList
                .add(currentLocationMarker.copyWith(positionParam: latLng));
          });

          _getNearbyUsers();
          _userMarker(userList);
          _addDummyUser();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.green),
      ),
    );
  }

  Widget buildCupertinoTextField() {
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
              borderRadius: BorderRadius.circular(0)),
          child: TextFormField(
              controller: destinationController,
              readOnly: true,
              onTap: () async {
                await showGoogleAutoComplete();
              },
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffA7A7A7)),
              decoration: InputDecoration(
                hintText: 'Search for a destination',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                border: InputBorder.none,
              ))),
    );
  }

  Future<void> showGoogleAutoComplete() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: _mode,
        language: 'en',
        onError: onError,
        strictbounds: false,
        types: [
          ""
        ],
        components: [
          Component(Component.country, "pk"),
          Component(Component.country, "usa")
        ]);

    displayPrediction(p!, homeScaffoldKey.currentState);
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

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    source = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    _addDummyUser();
    currentPosition = position;
    LatLng latLng = LatLng(position.latitude, position.longitude);
    setState(() {
      markersList.add(
        Marker(
          markerId: const MarkerId("current_location"),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
  }

  void _getNearbyUsers() async {
    // get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    // filter users to only include those within 5 kilometers of current position
    List<User> nearbyUsers = userList
        .where((user) =>
            Geolocator.distanceBetween(user.latitude, user.longitude,
                currentLatLng.latitude, currentLatLng.longitude) <=
            5000) // 5000 meters = 5 kilometers
        .toList();
    _userMarker(nearbyUsers);
    // add markers for nearby users
    for (var user in nearbyUsers) {
      final marker = Marker(
        markerId: MarkerId(user.id.toString()),
        position: LatLng(user.latitude, user.longitude),
        infoWindow: InfoWindow(
          title: user.name,
          snippet: '${user.ethnicity}, ${user.major},${user.name}',
        ),
      );

      setState(() {
        markersList.add(marker);
      });
    }
  }
}
