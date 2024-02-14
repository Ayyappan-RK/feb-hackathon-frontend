import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_summary_video_generation/common/YoutubeVideoExplorer.dart';

class VideoPlayerPage extends StatefulWidget {
  final String youtubeUrl;

  const VideoPlayerPage({Key? key, required this.youtubeUrl}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  String? _subtitle;

  @override
  void initState() {
    super.initState();
    _getSubtitles();
  }

  Future<void> _getSubtitles() async {
    try {
      _subtitle = await YoutubeVideoExplorer.getYoutubeCaptions(
          videoURL: widget.youtubeUrl);
      setState(() {});
    } catch (e) {
      print('Error getting subtitles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          if (_subtitle != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Subtitle: $_subtitle',
                style: const TextStyle(fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
