import 'package:chat/authentication/authservice.dart';
import 'package:chat/authentication/register_page.dart';
import 'package:chat/authentication/wrapper.dart';
import 'package:chat/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
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

  signin() async {
    setState(() {
      isloading = true;
    });
    if (emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty) {
      HapticFeedback.lightImpact();

      await Authservice().signin(emailcontroller.text, passwordcontroller.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Login Successful"),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
          backgroundColor: Colors.green,
          showCloseIcon: true,
        ));
      }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Wrapper()));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please fill all the required fields"),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
          showCloseIcon: true,
        ));
      }
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
          child: SingleChildScrollView(
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
                    Text(
                      'New Here?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
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
                    onPressed: () {}, child: const Text("Forget Password?")),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: isloading
                        ? null
                        : signin, // Disable button while loading
                    label: isloading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text("Sign In"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  child: GFButton(
                    position: GFPosition.start,
                    enableFeedback: true,
                    icon: Icon(FontAwesomeIcons.google),
                    type: GFButtonType.solid,
                    onPressed: () {
                      Authservice().googlesignin();
                    },
                    text: "Sign in with Google",
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    shape: GFButtonShape.pills,
                    fullWidthButton: true,
                    size: GFSize.LARGE,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
