import 'dart:io';

import 'package:chat/authentication/authservice.dart';
import 'package:chat/features/upload_data.dart';
import 'package:chat/pages/settings_screen/apprence_screen.dart';
import 'package:chat/pages/settings_screen/friendscreen.dart';
import 'package:chat/pages/settings_screen/notification_screen.dart';
import 'package:chat/provider/userdataprovider.dart';
import 'package:chat/widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchUserData(uid);
  }

  bool selected = false;
  final namecontroller = TextEditingController();
  final aboutcontroller = TextEditingController();
  File? selectedimage;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;
    Future<File?> pickImage() async {
      try {
        final picker = ImagePicker();
        final XFile? pickedimage =
            await picker.pickImage(source: ImageSource.gallery);
        if (pickedimage != null) {
          setState(() {
            selectedimage = File(pickedimage.path);
          });
          return File(pickedimage.path);
        } else {
          return null;
        }
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    title: const Text(
                      "Settings",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    subtitle: Text(userData['about']),
                    leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userData["imageurl"])),
                    title: Text(userData["name"] ?? ""),
                    trailing: FilledButton.tonal(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Wrap(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              userData['imageurl']),
                                          radius: 50,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            pickImage();
                                          },
                                          child: const Text('Change image'),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 20,
                                    ),
                                    MyTextfield(
                                        labeltext: "Name",
                                        controller: namecontroller,
                                        leading: const Icon(Iconsax.user)),
                                    Container(
                                      height: 20,
                                    ),
                                    MyTextfield(
                                        labeltext: "About",
                                        controller: aboutcontroller,
                                        leading:
                                            const Icon(Iconsax.information))
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      UploadData().updatadata(
                                          namecontroller.text,
                                          aboutcontroller.text,
                                          uid);
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                                title: Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text("Edit")),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Text(
                      "General",
                      style: TextStyle(color: Theme.of(context).indicatorColor),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationScreen()));
                    },
                    leading: const Icon(Iconsax.notification4),
                    title: const Text("Notification"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ApprenceScreen()));
                    },
                    leading: const Icon(Iconsax.teacher),
                    title: const Text("Apprence"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Friendscreen()));
                    },
                    leading: const Icon(Iconsax.people),
                    title: const Text("Friends"),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Iconsax.cloud),
                    title: const Text("Storage & Data"),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Iconsax.info_circle),
                    title: const Text("About"),
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Log Out",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            content: Text(
                              "Do You Want To LogOut",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Authservice().logout();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  )),
                              FilledButton.tonal(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No")),
                            ],
                          );
                        },
                      );
                    },
                    leading: const Icon(Iconsax.logout),
                    title: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
