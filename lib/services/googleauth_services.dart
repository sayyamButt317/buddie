import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Handler/search.dart';
import '../Views/login.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const Search();
          }
          return const Login();
        });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, get the user's location
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Store the location data in Firebase
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child("users");

    databaseReference.child(FirebaseAuth.instance.currentUser!.uid).set({
      'latitude': position.latitude,
      'longitude': position.longitude,
    });

    // Return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
