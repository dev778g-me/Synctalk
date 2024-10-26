import 'dart:io';

import 'package:chat/authentication/wrapper.dart';
import 'package:chat/features/upload_data.dart';
import 'package:chat/widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class AddDetails extends StatefulWidget {
  const AddDetails({super.key});

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  final namecontroller = TextEditingController();
  final aboutcontroller = TextEditingController();
  DateTime firstDate = DateTime(2000, 1, 1);
  DateTime lastDate = DateTime(2100, 12, 31);
  bool isloading = false;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final ImagePicker picker = ImagePicker();
  File? selectedimage;

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
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: selectedimage != null
                        ? FileImage(selectedimage!)
                        : null,
                    child: selectedimage == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                    radius: 80,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton.filled(
                          onPressed: () {
                            pickImage();
                          },
                          icon: const Icon(Icons.add_a_photo)))
                ],
              )),
              const SizedBox(
                height: 30,
              ),
              MyTextfield(
                  labeltext: "Name",
                  controller: namecontroller,
                  leading: const Icon(Iconsax.user)),
              const SizedBox(
                height: 20,
              ),
              MyTextfield(
                  labeltext: "About",
                  controller: aboutcontroller,
                  leading: const Icon(Iconsax.information)),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () async {
                    if (selectedimage != null) {
                      final imageUrl =
                          await UploadData().uploadImage(selectedimage!, uid);
                      if (imageUrl != null) {
                        await UploadData().uploaddata(
                            namecontroller.text, aboutcontroller.text, uid);
                        // Save `imageUrl` to Firestore here as needed
                      } else {
                        print("Error: Image URL is null");
                      }
                    } else {
                      print("Please select an image");
                    }
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Wrapper()));
                  },
                  label: Text("Continue"),
                  icon: Icon(Iconsax.activity),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
