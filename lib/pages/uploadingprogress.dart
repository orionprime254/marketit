import 'package:flutter/material.dart';
import 'package:marketit/ads/custom_rewardads.dart'; // Adjust the import as needed

class UploadProgressPage extends StatefulWidget {
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
  _UploadProgressPageState createState() => _UploadProgressPageState();
}

class _UploadProgressPageState extends State<UploadProgressPage> {
  late CustomRewardAd _rewardAd;

  @override
  void initState() {
    super.initState();
    _rewardAd = CustomRewardAd();
    _rewardAd.loadRewardedAd();
  }

  @override
  void dispose() {
    _rewardAd.dispose();
    super.dispose();
  }

  void _showRewardedAd() {
    if (_rewardAd.isAdLoaded()) {
      _rewardAd.showRewardedAd(onAdDismissed: (ad) {
        Navigator.pop(context, true); // Navigate back after ad is dismissed
      });
    } else {
      Navigator.pop(context, true); // Navigate back if ad is not ready
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.isSuccess ? 'U P L O A D S U C C E S S F U L' : 'U P L O A D I N G...'),
      ),
      body: Center(
        child: widget.isSuccess
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              SizedBox(height: 20),
              Text(
                'Upload Successful! Please be patient as admin reviews your upload :)',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showRewardedAd,
                child: Text(
                  'Return to Previous Page',
                  style: TextStyle(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
            : widget.errorMessage != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 100),
            SizedBox(height: 20),
            Text(
              'Upload Failed: ${widget.errorMessage}',
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
            CircularProgressIndicator(value: widget.progress),
            SizedBox(height: 20),
            Text(
              '${(widget.progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
