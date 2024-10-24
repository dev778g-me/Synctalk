import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:chat/authentication/authservice.dart';
import 'package:chat/authentication/register_page.dart';
import 'package:chat/authentication/wrapper.dart';
import 'package:chat/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                "Log In",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('New Here ?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                      child: const Text("Make Account")),
                ],
              ),
              MyTextfield(
                labeltext: "Email",
                controller: emailcontroller,
                leading: const Icon(Iconsax.paperclip),
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextfield(
                labeltext: "Password",
                controller: passwordcontroller,
                leading: const Icon(Iconsax.key),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {}, child: const Text("Forget Password ?")),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: FilledButton.tonalIcon(
                    onPressed: () {
                      if (emailcontroller.text.isNotEmpty &&
                          passwordcontroller.text.isNotEmpty) {
                        HapticFeedback.lightImpact();
                        setState(() {
                          isloading = true;
                        });
                        Authservice().signin(
                            emailcontroller.text, passwordcontroller.text);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Login Successfull"),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 5),
                          backgroundColor: Colors.green,
                          showCloseIcon: true,
                        ));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const Wrapper()));
                        setState(() {
                          isloading = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Please fill All the required fields"),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 5),
                          backgroundColor: Colors.red,
                          showCloseIcon: true,
                        ));
                      }
                    },
                    label: const Text("Sign In")),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text("New Here Create An Account")),
            ],
          ),
        ),
      ),
    );
  }
}
