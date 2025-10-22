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
    socket.connect();
    socket.onConnect((data) => print('onConnect:$data'));
    socket.onDisconnect((data) => print('onDisconnect:$data'));
    socket.onError((data) => print('onError:$data'));
    socket.on('welcome', (data) => print('WELCOME:$data'));
    socket.on('massage', (data) => print(' MASSAGE:$data'));


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: ctrl),
            SizedBox(height: 30.0),
            TextButton(
              onPressed: () {
                socket.emit('message', ctrl.text);
                ctrl.clear();
              },
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
