import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_events.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_states.dart';
import 'package:whatsapp_status_saver/flow/home_page/widgets/images_part/custom_grid_view.dart';
import 'package:whatsapp_status_saver/flow/home_page/widgets/images_part/native_ad.dart';

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
          return CustomScrollView(
            slivers: [
              CustomGridView.builder(
                context: context,
                list: bloc.imagesList,
              ),
              const SliverToBoxAdapter(
                child: NativeAdImages(),
              )
            ],
          );
         
        },
      ),
    );
  }
}
