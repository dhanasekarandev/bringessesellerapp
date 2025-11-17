import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoPlayerWidget extends StatefulWidget {
  final File? videoFile;
  final String? videoUrl;

  const VideoPlayerWidget({
    super.key,
    this.videoFile,
    this.videoUrl,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (widget.videoFile != null) {
        // Play from local file
        _controller = VideoPlayerController.file(widget.videoFile!);
      } else if (widget.videoUrl != null) {
        // Check cache for this video
        final fileInfo =
            await DefaultCacheManager().getFileFromCache(widget.videoUrl!);

        File file;
        if (fileInfo != null && fileInfo.file.existsSync()) {
          // Cached file exists
          file = fileInfo.file;
        } else {
          // Download and cache video
          file = await DefaultCacheManager().getSingleFile(widget.videoUrl!);
        }

        _controller = VideoPlayerController.file(file);
      } else {
        throw Exception("No video source provided");
      }

      await _controller.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        looping: false,
        showControls: false, // hide default controls
      );

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("Error initializing video: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_chewieController == null || !_controller.value.isInitialized) {
      return const Center(child: Text("Failed to load video"));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),

        // Custom Play / Pause button
        GestureDetector(
          onTap: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
