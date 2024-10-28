import 'package:chat/provider/contactsprovider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class Contactsscreen extends StatelessWidget {
  const Contactsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactprovider =
        Provider.of<Contactsprovider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      contactprovider.fetchcontacts();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Iconsax.more))],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              backgroundColor: WidgetStateColor.resolveWith(
                  (states) => Theme.of(context).colorScheme.inversePrimary),
              elevation: WidgetStateProperty.all(0), // Set elevation to 0
              hintText: "Search Contacts",
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(Icons.search,
                    color: Theme.of(context).colorScheme.primary),
              ),
              onChanged: (query) {
                // Handle search functionality here
              },
            ),
          ),
          Consumer<Contactsprovider>(
            builder: (context, provider, child) {
              return provider.contacts.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView.builder(
                        itemCount: provider.contacts.length,
                        itemBuilder: (context, index) {
                          final contact = provider.contacts[index];
                          return ListTile(
                            onTap: () {},
                            title: Text(contact.displayName),
                            subtitle: Text(contact.phones.isNotEmpty
                                ? contact.phones.first.number
                                : "no number"),
                            leading: contact.photo == null
                                ? const CircleAvatar(
                                    child: Icon(Iconsax.user),
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.photo!),
                                  ),
                          );
                        },
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
