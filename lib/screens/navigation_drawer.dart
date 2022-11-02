import 'package:blood_app/screens/drawer_item.dart';
import 'package:blood_app/pages/people.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../pages/chats.dart';
import '../pages/my_account.dart';
import '../pages/settings.dart';
import 'login_screen.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    Reference ref = FirebaseStorage.instance.ref().child("profilepic.jpg");

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
          color: Colors.red.shade600,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 60, 24, 0),
            child: Column(children: [
              headerWidget(),
              const SizedBox(
                height: 40,
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 40,
              ),
              DrawerItem(
                  name: 'People',
                  icon: Icons.people,
                  onPressed: () => onItemPressed(context, index: 0)),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'My Account',
                  icon: Icons.account_box_rounded,
                  onPressed: () => onItemPressed(context, index: 1)),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'Chats',
                  icon: Icons.message_outlined,
                  onPressed: () => onItemPressed(context, index: 2)),
              const SizedBox(
                height: 30,
              ),
              // DrawerItem(
              //     name: 'Favourites',
              //     icon: Icons.favorite_outline,
              //     onPressed: () => onItemPressed(context, index: 3)),
              // const SizedBox(
              //   height: 30,
              // ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'Settings',
                  icon: Icons.settings,
                  onPressed: () => onItemPressed(context, index: 4)),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'Log Out',
                  icon: Icons.logout,
                  onPressed: () => onItemPressed(context, index: 5)),
            ]),
          )),
    );
  }

  void onItemPressed(BuildContext context, {required int index}) {
    Navigator.pop(context);

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const People()));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const myAccount()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const chats()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const settings()));
        break;
      case 5:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,);
        Fluttertoast.showToast(
            msg: "You have logged out", backgroundColor: Colors.red);
        break;
      default:
        Navigator.pop(context);
        break;
    }
  }

  Widget headerWidget() {
    const url =
        'https://www.artofliving.org/sites/www.artofliving.org/files/styles/original_image/public/wysiwyg_imageupload/guilherme-stecanella-375176-unsplash.jpg.webp?itok=lR2wOhfN';
    return Row(
      children: [
         CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(url),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Mama Lucy Hospital',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            SizedBox(
              height: 10,
            ),
            Text('World Class Healthcare',
                style: TextStyle(fontSize: 14, color: Colors.white))
          ],
        )
      ],
    );
  }
}
