import 'package:chat/authentication/authservice.dart';
import 'package:chat/authentication/login_screen.dart';
import 'package:chat/authentication/wrapper.dart';
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
  bool isloading = false;
  createaccount() async {
    setState(() {
      isloading = true;
    });
    if (emailcontroller.text.isNotEmpty &&
        passwordcontroller.text.isNotEmpty &&
        passwordcontroller.text == confirmpasswordcontroller.text) {
      HapticFeedback.lightImpact();

      await Authservice()
          .craeteaccount(emailcontroller.text, passwordcontroller.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Created Account Successfully"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.green,
        showCloseIcon: true,
      ));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Wrapper()));
    } else if (passwordcontroller.text != confirmpasswordcontroller.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Mismatch detected! Please ensure both passwords are the same"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        showCloseIcon: true,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all the required fields"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        showCloseIcon: true,
      ));
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                "Make Account",
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
                  Text(
                    'Already have an account',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Login")),
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
                height: 30,
              ),
              MyTextfield(
                labeltext: "Confirm Password",
                controller: confirmpasswordcontroller,
                leading: const Icon(Iconsax.key),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: isloading
                      ? null
                      : createaccount, // Disable button while loading
                  label: isloading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text("Create Account"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
