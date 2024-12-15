import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NoiseCraftService {
  final WebSocketChannel channel;

  NoiseCraftService(String url)
      : channel = WebSocketChannel.connect(Uri.parse(url));

  Stream<dynamic> get events => channel.stream;

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close();
  }
}
