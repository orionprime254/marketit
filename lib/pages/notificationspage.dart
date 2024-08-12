import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the message from the arguments
    final RemoteMessage? message = ModalRoute.of(context)!.settings.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('N O T I F I C A T I O N S')),
      ),
      body: message == null
          ? Center(child: Text('No Notification Data'))
          : Column(
        children: [
          if (message.notification != null) ...[
            Text(message.notification!.title ?? 'No Title'),
            Text(message.notification!.body ?? 'No Body'),
          ],
          Text(message.data.toString()),
        ],
      ),
    );
  }
}
