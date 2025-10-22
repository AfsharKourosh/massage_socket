import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MassageScreen extends StatefulWidget {
  const MassageScreen({super.key});

  @override
  State<MassageScreen> createState() => _MassageScreenState();
}

class _MassageScreenState extends State<MassageScreen> {
  late Socket socket;
  final ctrl = TextEditingController();
  final streamController = StreamController<String>();
  List<String> chats = [];

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  initSocket() {
    socket = io(
      'http://10.0.2.2:3004',
      OptionBuilder()
          .setTransports(["websocket"])
          .disableAutoConnect()
          .enableForceNew()
          .build(),
    );
    socket.onConnect((data) => print('onConnect:$data'));
    socket.onDisconnect((data) => print('onDisconnect:$data'));
    socket.onError((data) => print('onError:$data'));
    socket.onAny((event, data) => print('onAny: event: $event data: $data'));

    socket.on('welcome', (data) => print('WELCOME:$data'));
    socket.on('message', (data) {
      chats.add(data);
    streamController.sink.add(data);
  });
    socket.connect();

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60.0),
            SizedBox(height: 60.0, child: TextField(controller: ctrl)),
            SizedBox(height: 30.0),
            SizedBox(
              height: 60.0,
              child: TextButton(
                onPressed: () {
                  socket.emit('message', ctrl.text);
                  ctrl.clear();
                },
                child: Text('Send Message'),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: streamController.stream,
                builder: (context, snapshot) => ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) => Text(chats[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
