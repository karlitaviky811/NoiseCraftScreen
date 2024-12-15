import 'package:flutter/material.dart';
import 'package:localnotificationssecondoption/nose_service.dart';


class NoiseCraftScreen extends StatefulWidget {
  @override
  _NoiseCraftScreenState createState() => _NoiseCraftScreenState();
}

class _NoiseCraftScreenState extends State<NoiseCraftScreen> {
  late NoiseCraftService _noiseCraftService;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noiseCraftService = NoiseCraftService('wss://noisecraft.app/1118');  // URL de NoiseCraft
  }

  @override
  void dispose() {
    _noiseCraftService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoiseCraft Events'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _noiseCraftService.events,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: [
                    ListTile(
                      title: Text(snapshot.data.toString()),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Send a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _noiseCraftService.sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: NoiseCraftScreen(),
));
