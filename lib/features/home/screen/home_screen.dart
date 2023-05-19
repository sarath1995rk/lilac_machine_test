import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:lilac_machine_test/app_config/constants.dart';
import 'package:lilac_machine_test/features/home/view_model/home_view_model.dart';
import 'package:lilac_machine_test/features/home/widget/custom_video_player_widget.dart';
import 'package:lilac_machine_test/features/home/widget/drawer_widget.dart';
import 'package:lilac_machine_test/widgets/custom_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io' as io;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;

  late Future<void> _initializeVideoPlayerFuture;

  late Future<void> videoDownloadedFuture;

  bool _videoDownloaded = false;

  @override
  void initState() {
    ///prevent screenshot
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

    ///check whether video is downloaded
    videoDownloadedFuture = isVideoDownloaded();

    ///initialize video Player controller
    _controller = VideoPlayerController.network(AppConstants.videoLink1);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    _controller.videoPlayerOptions?.allowBackgroundPlayback;
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    ///dispose video Player controller
    _controller.dispose();
    super.dispose();
  }

  Future<void> isVideoDownloaded() async {
    _videoDownloaded = await io.File(AppConstants.videoEncryptedLink).exists();
    if (mounted) {
      await Provider.of<HomeViewModel>(context,
          listen: false).decryptFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video player')),
      drawer: DrawerWidget(),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: videoDownloadedFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomProgressBar();
                  }
                  return Column(
                    children: [
                      Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: CustomVideoPlayerWidget(
                            media: _videoDownloaded
                                ? AppConstants.videoDownloadedPath
                                : AppConstants.videoLink3,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      _videoDownloaded
                          ? const ElevatedButton(
                              onPressed: null, child: Text('Video downloaded'))
                          : Consumer<HomeViewModel>(
                              builder: (_, viewModel, __) {
                              return ElevatedButton(
                                  onPressed: () async {
                                    final response =  await Provider.of<HomeViewModel>(context,
                                            listen: false)
                                        .downloadVideo(
                                            path: AppConstants.videoLink3,
                                            context: context);
                                    if(response){
                                      setState(() {
                                        _videoDownloaded = true;
                                      });
                                    }
                                  },
                                  child: viewModel.loading
                                      ? const FittedBox(
                                          child: CustomProgressBar(),
                                        )
                                      : const Text('Download'));
                            })
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
