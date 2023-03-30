import 'package:buddie/Handler/available.dart';
import 'package:buddie/Handler/searchlocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'filter.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/map.png"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                color: Colors.green,
                minSize: 48,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: const Text(
                  'Search',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                onPressed: () => Get.to(() => const SearchPlacesScreen()),
              ),
              const SizedBox(
                height: 14,
              ),
              CupertinoButton(
                color: Colors.green,
                minSize: 48,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                onPressed: () => Get.to(() => const Filter()),
              ),
              const SizedBox(
                height: 14,
              ),
              CupertinoButton(
                color: Colors.green,
                minSize: 48,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: const Text(
                  'Enter Your Availability',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                onPressed: () => Get.to(() => const Availability()),
              ),
              Container(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
