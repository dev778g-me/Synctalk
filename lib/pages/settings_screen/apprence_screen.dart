import 'package:chat/provider/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApprenceScreen extends StatelessWidget {
  const ApprenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themenotifier = Provider.of<Themeprovider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apprence"),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: Text("Change System Theme"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Change Theme",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //system default options
                          RadioListTile(
                              title: const Text("System Default"),
                              value: ThemeMode.system,
                              groupValue: themenotifier.thememode,
                              onChanged: (ThemeMode? value) {
                                if (value != null) {
                                  themenotifier.settheme(value);
                                  Navigator.pop(context);
                                }
                              }),
                          RadioListTile(
                              title: const Text("Light"),
                              value: ThemeMode.light,
                              groupValue: themenotifier.thememode,
                              onChanged: (ThemeMode? value) {
                                if (value != null) {
                                  themenotifier.settheme(value);
                                  Navigator.pop(context);
                                }
                              }),
                          RadioListTile(
                              title: const Text("Dark"),
                              value: ThemeMode.dark,
                              groupValue: themenotifier.thememode,
                              onChanged: (ThemeMode? value) {
                                if (value != null) {
                                  themenotifier.settheme(value);
                                  Navigator.pop(context);
                                }
                              })
                        ],
                      ),
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
