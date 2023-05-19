import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilac_machine_test/app_config/routes.dart' as route;
import 'package:lilac_machine_test/app_config/theme_provider.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
   DrawerWidget({
    super.key,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ), //BoxDecoration
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              accountName:  Text(
                _auth.currentUser?.displayName ?? 'User',
                style: const TextStyle(fontSize: 18),
              ),
              accountEmail: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Text(  _auth.currentUser?.phoneNumber ?? '',),
                  Text(  _auth.currentUser?.email ?? '',),

                ],
              ),
              currentAccountPictureSize: const Size.square(40),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 165, 255, 137),
                backgroundImage: NetworkImage(
                    "https://www.shutterstock.com/image-photo/head-shot-portrait-close-smiling-260nw-1714666150.jpg"),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch.adaptive(value: themeChanger.getTheme == ThemeMode.dark ? true : false, onChanged: (newVal){
            Provider.of<ThemeChanger>(context,listen: false).toggleTheme();
            }),

          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, route.kPhoneAuthScreen, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}