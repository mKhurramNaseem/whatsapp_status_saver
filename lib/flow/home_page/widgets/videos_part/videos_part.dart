import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_events.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_states.dart';
import 'package:whatsapp_status_saver/util/app_theme.dart';

class VideosPart extends StatelessWidget {
  const VideosPart({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomePageBloc>();
    return BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
      return GridView.builder(
        itemCount: bloc.videosList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        addAutomaticKeepAlives: true,
        cacheExtent: 10.0,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: VideoGridTile(
              video: bloc.videosList[index],
            ),
          );
        },
      );
    });
  }
}

class VideoGridTile extends StatefulWidget {
  final String video;
  const VideoGridTile({super.key, required this.video});

  @override
  State<VideoGridTile> createState() => _VideoGridTileState();
}

class _VideoGridTileState extends State<VideoGridTile> {
  Future<String>? future;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<HomePageBloc>();
    future = bloc.getThumbnailFromVideo(widget.video);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomePageBloc>();
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Positioned.fill(
                  child: InkWell(
                    onTap: () async {
                      bloc.add(HomePageVideoNavigateEvent(video: widget.video));
                    },
                    child: Image.file(
                      File(snapshot.data!),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return InkWell(
                        onTap: () {
                          bloc.add(
                            HomePageVideoSaveEvent(
                              videoPath: widget.video,
                            ),
                          );
                        },
                        child: Icon(
                          Icons.play_circle_outline,
                          color: AppColor.whiteColor,
                          size: constraints.maxHeight * 0.25,
                        ),
                      );
                    }),
                  ),
                ),
                InkWell(
                  onTap: () {
                    bloc.add(
                      HomePageVideoSaveEvent(
                        videoPath: widget.video,
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: AppColor.greenColor,
                      child: Icon(
                        Icons.download,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
