import 'package:flutter/material.dart';

class UploadProgressPage extends StatelessWidget {
  final double progress;
  final String? errorMessage;
  final bool isSuccess;

  const UploadProgressPage({
    Key? key,
    required this.progress,
    this.errorMessage,
    this.isSuccess = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSuccess ? 'Upload Successful' : 'Uploading...'),
      ),
      body: Center(
        child: isSuccess
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text(
              'Upload Successful!Please be patient as admin reviews your upload :)',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Return to Previous Page'),
            ),
          ],
        )
            : errorMessage != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 100),
            SizedBox(height: 20),
            Text(
              'Upload Failed: $errorMessage',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Retry'),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(value: progress),
            SizedBox(height: 20),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
