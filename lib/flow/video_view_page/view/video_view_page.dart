import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_events.dart';

class VideoViewPage extends StatefulWidget {
  final File temp;
  const VideoViewPage({super.key, required this.temp});

  @override
  State<VideoViewPage> createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    videoPlayerController = VideoPlayerController.file(widget.temp);
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        additionalOptions: (context) {
          return [
            OptionItem(onTap: () async {
              await Share.shareXFiles(
                [
                  XFile(widget.temp.path),
                ],
              );
            }, iconData: Icons.share, title: 'Share'),
            OptionItem(onTap: () {
               final bloc = context.read<HomePageBloc>();
               bloc.add(HomePageVideoSaveEvent(videoPath: widget.temp.path));
               Navigator.of(context).pop();
            }, iconData: Icons.download, title: 'Save'),
          ];
        },  
                            
        zoomAndPan: true,
        autoInitialize: true,
        autoPlay: true,
        looping: false);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black26,
        body: Center(
          child: Chewie(controller: chewieController),
        ),
      ),
    );
  }
}
