import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketHome extends StatefulWidget {
  const SocketHome({Key? key}) : super(key: key);

  @override
  State<SocketHome> createState() => _SocketHomeState();
}

class _SocketHomeState extends State<SocketHome> {
  final TextEditingController my_controller = TextEditingController();
  final my_channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          'Web Socket Demo',
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          colors: const [
            Colors.purpleAccent,
            Colors.yellowAccent,
            Colors.lightGreenAccent
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
                child: TextFormField(
              controller: my_controller,
              decoration: const InputDecoration(labelText: 'Send Message'),
            )),
            const SizedBox(
              height: 24,
            ),
            StreamBuilder(
                stream: my_channel.stream,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData ? '${snapshot.data}' : '',
                    style: const TextStyle(color: Colors.indigoAccent),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendMessage,
        tooltip: 'Send Message',
        child: const Icon(Icons.send),
      ),
    );
  }

  // sending message
  void sendMessage() {
    if (my_controller.text.isNotEmpty) {
      my_channel.sink.add(my_controller.text);
      my_controller.text = '';
    }
  }

  // close the connection
  @override
  void dispose() {
    my_channel.sink.close();
    my_controller.dispose();
    super.dispose();
  }
}
