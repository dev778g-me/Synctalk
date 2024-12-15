import 'package:chat/models/chatmessagemodel.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SecondChat extends StatefulWidget {
  final String receiverid;
  final String name;
  final String pfpurl;
  const SecondChat(
      {super.key,
      required this.receiverid,
      required this.name,
      required this.pfpurl});

  @override
  State<SecondChat> createState() => _SecondChatState();
}

class _SecondChatState extends State<SecondChat> {
  List<Chatmessagemodel> messages = [
    Chatmessagemodel(messagecontent: "Hello Debansh", messagetype: 'receiver'),
    Chatmessagemodel(messagecontent: "doing ok", messagetype: 'sender')
  ];
  @override
  Widget build(BuildContext context) {
    final messagecontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        elevation: 10,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.pfpurl),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.video),
            onPressed: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => Call()));
            },
          ),
          IconButton(icon: const Icon(Iconsax.call), onPressed: () {}),
          IconButton(icon: const Icon(Iconsax.more), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].messagetype == "sender"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messagetype == "receiver"
                          ? Colors.grey.shade200
                          : Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      messages[index].messagecontent,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
            itemCount: messages.length,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              child: Row(
                children: [
                  // Container(
                  //     height: 30,
                  //     width: 30,
                  //     decoration: BoxDecoration(
                  //         color: const Color(0xFF2962FF),
                  //         borderRadius: BorderRadius.circular(30)),
                  //     child: GestureDetector(
                  //         child: Icon(
                  //       Iconsax.send,
                  //       color: Colors.white,
                  //       size: 20,
                  //     )))

                  Expanded(
                    child: TextField(
                      controller: messagecontroller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),

                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerLow, // Background color
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              BorderSide.none, // No border when not focused
                        ),

                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.emoji_emotions_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          onPressed: () {
                            // Add emoji picker functionality here
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          onPressed: () {
                            // Attach files or images
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FloatingActionButton.small(
                      onPressed: () {
                        messages.add(Chatmessagemodel(
                            messagecontent: messagecontroller.text,
                            messagetype: 'messagetype'));
                        setState(() {});
                      },
                      child: Icon(Iconsax.send),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
