import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:lilac_machine_test/widgets/custom_progress_bar.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayerWidget extends StatefulWidget {
  const CustomVideoPlayerWidget({Key? key, required this.media}) : super(key: key);
  final String? media;

  @override
  _ChatVideoPlayerState createState() => _ChatVideoPlayerState();
}

class _ChatVideoPlayerState extends State<CustomVideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  bool isPaused = false;
  bool initialized = false;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    if (widget.media != null) {
      initializePlayer();
    }
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.media!);
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        fullScreenByDefault: true,
        progressIndicatorDelay:
        bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
        showControlsOnInitialize: true,
        showOptions: true,
        showControls: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
            child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
              controller: _chewieController!,
            )
                :  const CustomProgressBar()
          );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
