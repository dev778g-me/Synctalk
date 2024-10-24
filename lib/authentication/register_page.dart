import 'package:chat/authentication/authservice.dart';
import 'package:chat/authentication/login_screen.dart';
import 'package:chat/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                "Make Account",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color: Theme.of(context).colorScheme.primary),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Already have an account'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text("Login")),
                ],
              ),
              MyTextfield(
                labeltext: "Email",
                controller: emailcontroller,
                leading: Icon(Iconsax.paperclip),
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextfield(
                labeltext: "Password",
                controller: passwordcontroller,
                leading: Icon(Iconsax.key),
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextfield(
                labeltext: "Confirm Password",
                controller: confirmpasswordcontroller,
                leading: Icon(Iconsax.key),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: FilledButton.tonalIcon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Authservice().craeteaccount(
                          emailcontroller.text, passwordcontroller.text);
                    },
                    label: Text("Create Account")),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
