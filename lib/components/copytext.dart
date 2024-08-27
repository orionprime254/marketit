import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard functionality

class CopyTextWithIcon extends StatefulWidget {
  const CopyTextWithIcon({Key? key}) : super(key: key);

  @override
  _CopyTextWithIconState createState() => _CopyTextWithIconState();
}

class _CopyTextWithIconState extends State<CopyTextWithIcon> {
  final String _textToCopy = "0793997938";

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Copy Text with Icon Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: SelectableText(
                _textToCopy,
                style: const TextStyle(fontSize: 18),
                onTap: _copyToClipboard, // Optional: If you want to copy on text tap as well
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: _copyToClipboard,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CopyTextWithIcon(),
  ));
}
