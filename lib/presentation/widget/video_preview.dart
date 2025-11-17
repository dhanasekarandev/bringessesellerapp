import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class UploadPreviewUrl extends StatefulWidget {
  final String videoUrl;
  final VoidCallback onRemove;

  const UploadPreviewUrl({
    super.key,
    required this.videoUrl,
    required this.onRemove,
  });

  @override
  State<UploadPreviewUrl> createState() => _UploadPreviewUrlState();
}

class _UploadPreviewUrlState extends State<UploadPreviewUrl> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl);
    _videoController.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        showControls: true,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null || !_videoController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.topRight,
      children: [
        SizedBox(
          height: 180.h,
          child: Chewie(controller: _chewieController!),
        ),
        GestureDetector(
          onTap: widget.onRemove,
          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}
