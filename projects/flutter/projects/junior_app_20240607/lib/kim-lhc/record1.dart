import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import 'record2.dart';

void main() {
  runApp(const record1());
}

class record1 extends StatelessWidget {
  const record1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoPlayPage(),
    );
  }
}

class VideoPlayPage extends StatefulWidget {
  const VideoPlayPage({Key? key}) : super(key: key);

  @override
  _VideoPlayPageState createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  late VideoPlayerController _videoPlayerController;
  bool _isVideoPlaying = false;
  final String videoPath =
      'data/data/com.example.junior_app_20240607/cache/body.mp4';

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _initVideoPlayer() {
    _videoPlayerController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _toggleVideo() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
    setState(() {
      _isVideoPlaying = !_isVideoPlaying;
    });
  }

  void _stopVideo() {
    _videoPlayerController.pause();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoPage(filePath: videoPath)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            if (_videoPlayerController.value.isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoPlayerController.value.size.width,
                    height: _videoPlayerController.value.size.height,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                ),
              )
            else
              const CircularProgressIndicator(),
            Positioned(
              bottom: 25,
              left: 170,
              child: FloatingActionButton(
                backgroundColor: _isVideoPlaying ? Colors.blue : Colors.red,
                onPressed: () {
                  if (_isVideoPlaying) {
                    _stopVideo();
                  } else {
                    _toggleVideo();
                  }
                },
                child: Icon(_isVideoPlaying ? Icons.stop : Icons.circle),
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
