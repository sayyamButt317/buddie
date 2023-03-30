import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Handler/search.dart';
import '../views/profile.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>(debugLabel: '_formKey');
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    checkLogin();
  }

  void checkLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter both email and password');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString(),
      );

      if (FirebaseAuth.instance.currentUser != null) {
        // Navigate to the home page after successful login
        Get.offAll(() => const Search());
      } else {
        // Navigate to the page to enter profile info
        Get.offAll(() => const Signup());
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'An error occurred while logging in';
      if (error.code == 'user-not-found') {
        errorMessage = 'User not found';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Invalid password';
      }

      debugPrint(error.toString());

      Get.snackbar('Error', errorMessage);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      endDrawer: Drawer(
  child: Container(
    color: Colors.green,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        backgroundColor: CupertinoColors.white,
        leading: Image(
          image: const AssetImage("images/Buddie.png"),
          height: height * 0.02,
        ),
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            children: const [
              Expanded(
                child: Image(
                  image: AssetImage("images/uic.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Text(
              "Please log in to UIC Shibboleth to                                "
              " Continue ",
              style: TextStyle(
                fontSize: 30,
                height: 1.3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(height: 10),
          Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 0, top: 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 0, top: 0),
                    child: CupertinoTextFormFieldRow(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      placeholder: "UIC NetID or EmailAddress ",
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please UIC NetID or EmailAddress ";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 0, top: 0),
                    child: CupertinoTextFormFieldRow(
                      controller: passwordController,
                      placeholder: " Password",
                      obscureText: true,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your password";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 40,
              ),
              CupertinoButton(
                color: Colors.green,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    checkLogin();
                  }
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ],
          ),
          Container(height: 42),
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Forget Password?\n",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text.rich(
              TextSpan(
                text:
                    'To reset your password, visit the University of Illinois\n',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17.2),
                children: <TextSpan>[
                  TextSpan(
                    text: 'NetID',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 17.2,
                      color: Colors.lightBlue,
                    ),
                  ),
                  TextSpan(
                    text: ' Center',
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 17.2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  child: Image.asset(
                    'images/message.png',
                    height: 30, // adjust the height as needed
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Container(
            color: Colors.green,
            child: Align(
              alignment: FractionalOffset.bottomCenter, // set background color
              child: Row(
                children: const [
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: Center(
                        child: Text(
                          '@Copyright 2023 | BUDDIE-UP All Rights Reserved',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
