import 'package:buddie/Views/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
      ),
      appBar: AppBar(
        backgroundColor: Colors.white, // set appbar background color to green
        automaticallyImplyLeading: false,
        title: Image(
          image: const AssetImage("images/Buddie.png"),
          height: height * 0.05,
        ),
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage("images/Buddie.png"),
              height: height * 0.2,
            ),
            const SizedBox(height: 16),
            const Text(
              "Never Walk Alone",
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 0.5,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: () => Get.to(() => const Login()),
              minSize: 44,
              color: Colors.green,
              child: const Text(
                'Login Via UIC',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
