
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_status_saver/ad_widgets/banner_ad.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_events.dart';
// import 'package:share_plus/share_plus.dart';

class ImageViewPage extends StatefulWidget {
  final String filePath;
  const ImageViewPage({super.key, required this.filePath});

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          Builder(builder: (context) {
            return InkWell(
              onTap: () async {
                final bloc = context.read<HomePageBloc>();
                bloc.add(HomePageImageSaveEvent(imagePath: widget.filePath));
              },
              borderRadius: BorderRadius.circular(50.0),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.download),
              ),
            );
          }),
          InkWell(
            onTap: () async {
              await Share.shareXFiles(
                [
                  XFile(widget.filePath),
                ],
              );
            },
            borderRadius: BorderRadius.circular(50.0),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.share_rounded),
            ),
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: widget.filePath,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PhotoView(
                minScale: PhotoViewComputedScale.contained,
                imageProvider: FileImage(
                  File(widget.filePath),
                ),
              ),
              const AppBannerAd(),
            ],
          ),
        ),
      ),
    );
  }
}
