import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_events.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_states.dart';
import 'package:whatsapp_status_saver/flow/image_view_page/view/image_view_page.dart';
import 'package:whatsapp_status_saver/util/app_theme.dart';

class ImagesPart extends StatelessWidget {
  const ImagesPart({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomePageBloc>();
    bloc.add(HomePageInitialEvent());
    return RefreshIndicator(
      onRefresh: () {
        bloc.add(HomePageInitialEvent());
        return Future.value(null);
      },
      child: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          log('Building');
          if (bloc.imagesList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_rounded,
                    color: Colors.grey,
                    size: 200,
                  ),
                  Text(
                    'No Status Available',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            itemCount: bloc.imagesList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              final filePath = bloc.imagesList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Positioned.fill(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: bloc,
                                child: ImageViewPage(
                                  filePath: filePath,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: filePath,
                          child: Image.file(
                            File(
                              filePath,
                            ),
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                  Icons.image_not_supported_outlined);
                            },
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        bloc.add(
                          HomePageImageSaveEvent(
                            imagePath: filePath,
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
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
