import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import '../Handler/search.dart';

class Signup extends StatefulWidget {
  const Signup({
    Key? key,
  }) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late final _name = TextEditingController();
  late final _lastname = TextEditingController();
  late final _gender = TextEditingController();
  late final _language = TextEditingController();
  late final _phone = TextEditingController();
  late final _ethnicity = TextEditingController();
  late final _majors = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkProfileInfo();

    setState(() {});
  }

  Future<void> checkProfileInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final hasProfileInfo = prefs.getBool('hasProfileInfo') ?? false;

    if (hasProfileInfo) {
      await loadData();
    }
  }

  Future<void> saveProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasProfileInfo', true);
    await prefs.setString('name', _name.text);
    await prefs.setString('lastname', _lastname.text);
    await prefs.setString('gender', _gender.text);
    await prefs.setString('language', _language.text);
    await prefs.setString('phone', _phone.text);
    await prefs.setString('ethnicity', _ethnicity.text);
    await prefs.setString('majors', _majors.text);
  }

  Future<void> loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _name.text = prefs.getString('name') ?? '';
      _lastname.text = prefs.getString('lastname') ?? '';
      _gender.text = prefs.getString('gender') ?? '';
      _language.text = prefs.getString('language') ?? '';
      _phone.text = prefs.getString('phone') ?? '';
      _ethnicity.text = prefs.getString('ethnicity') ?? '';
      _majors.text = prefs.getString('majors') ?? '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading data.')),
      );
    }
  }

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> _getImage(ImageSource camera) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  Future<String> uploadImage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance.ref().child('users/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        imageUrl = value;
        debugPrint("Download URL: $value");
      },
    );
    return imageUrl;
  }

  storeUserInfo() async {
    String url = await uploadImage(selectedImage!);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url,
    }).then((value) {});
  }

  @override
  void dispose() {
    _name.dispose();
    _lastname.dispose();
    _gender.dispose();
    _language.dispose();
    _phone.dispose();
    _ethnicity.dispose();
    _majors.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      endDrawer: Drawer(
        child: Container(
          color: Colors.green, // set the background color here
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
              const ListTile(
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const ListTile(
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
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
              const ListTile(
                title: Text(
                  'Contact',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image(
          image: const AssetImage(
            "images/Buddie.png",
          ),
          height: height * 0.05,
        ),
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Personal Information",
                      style: TextStyle(
                          fontSize: 28,
                          height: 1.8,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.2,
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            _getImage(ImageSource.camera);
                          },
                          child: selectedImage == null
                              ? Container(
                                  width: 120,
                                  height: 120,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                  child: const Center(
                                      child: Icon(Icons.camera_alt_outlined,
                                          size: 40, color: Colors.white)),
                                )
                              : Container(
                                  width: 120,
                                  height: 120,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(selectedImage!),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    height: 15,
                  ),
                  CupertinoTextField(
                    controller: _name,
                    placeholder: "Name",
                    keyboardType: TextInputType.text,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    textInputAction: TextInputAction.next,
                  ),
                  Container(
                    height: 14,
                  ),
                  CupertinoTextField(
                    controller: _lastname,
                    placeholder: "Last Name",
                    keyboardType: TextInputType.text,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    textInputAction: TextInputAction.next,
                  ),
                  Container(
                    height: 14,
                  ),
                  CupertinoTextField(
                    controller: _gender,
                    placeholder: "Gender",
                    keyboardType: TextInputType.text,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    textInputAction: TextInputAction.next,
                  ),
                  Container(
                    height: 14,
                  ),
                  SizedBox(
                    child: CupertinoTextField(
                      controller: _language,
                      placeholder: "Language",
                      keyboardType: TextInputType.text,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Container(
                    height: 14,
                  ),
                  CupertinoTextField(
                    controller: _phone,
                    placeholder: "Phone Number",
                    keyboardType: TextInputType.phone,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    textInputAction: TextInputAction.next,
                  ),
                  Container(
                    height: 14,
                  ),
                  CupertinoTextField(
                    controller: _ethnicity,
                    placeholder: "Ethnicity",
                    keyboardType: TextInputType.text,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    textInputAction: TextInputAction.next,
                  ),
                  Container(
                    height: 14,
                  ),
                  CupertinoTextField(
                    controller: _majors,
                    placeholder: "Majors",
                    keyboardType: TextInputType.text,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                            color: Colors.green,
                            minSize: 48,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () async {
                              await saveProfileInfo();

                              // Check for empty fields
                              if (_name.text.isEmpty ||
                                  _lastname.text.isEmpty ||
                                  _gender.text.isEmpty ||
                                  _language.text.isEmpty ||
                                  _phone.text.isEmpty ||
                                  _ethnicity.text.isEmpty ||
                                  _majors.text.isEmpty ||
                                  selectedImage == null) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please fill all required feilds'),
                                  ),
                                );
                              } else {
                                saveProfileInfo();
                                Get.offAll(() => const Search());
                                // ignore: use_build_context_synchronously
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
