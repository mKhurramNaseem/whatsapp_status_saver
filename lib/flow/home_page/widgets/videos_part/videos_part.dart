import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_events.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_states.dart';
import 'package:whatsapp_status_saver/util/app_theme.dart';
import 'package:whatsapp_status_saver/util/connectivity_manager.dart';

class VideosPart extends StatelessWidget {
  const VideosPart({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomePageBloc>();
    bloc.add(HomePageInitialEvent());
    return RefreshIndicator(
      onRefresh: () {
        bloc.add(HomePageInitialEvent());
        return Future.value(null);
      },
      child:
          BlocBuilder<HomePageBloc, HomePageState>(builder: (context, state) {
        if (bloc.videosList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.videoSlash,
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
          itemCount: bloc.videosList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
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
      }),
    );
  }
}

class VideoGridTile extends StatefulWidget {
  final String video;
  const VideoGridTile({super.key, required this.video});

  @override
  State<VideoGridTile> createState() => _VideoGridTileState();
}

class _VideoGridTileState extends State<VideoGridTile> {
  static const _adUnit = 'ca-app-pub-3940256099942544/1033173712';
  InterstitialAd? _interstitialAd;
  Future<String>? future;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<HomePageBloc>();
    future = bloc.getThumbnailFromVideo(widget.video);
    ConnectivityManager.isConnectivityChanged().listen(
      (event) async {
        bool isConnected = await ConnectivityManager.isConnected(event);
        if (isConnected) {
          loadAd();
        }
      },
    );
    loadAd();
  }

  loadAd() async {
    bool isConnected = await ConnectivityManager.isConnected();
    if (isConnected) {
      await InterstitialAd.load(
        adUnitId: _adUnit,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            log('[$ad Loaded]');
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {},
              onAdImpression: (ad) {},
              onAdFailedToShowFullScreenContent: (ad, error) {
                _isLoaded = false;
                ad.dispose();
              },
              onAdDismissedFullScreenContent: (ad) {
                final bloc = context.read<HomePageBloc>();
                bloc.add(HomePageVideoNavigateEvent(video: widget.video));
                _isLoaded = false;
                ad.dispose();
              },
              onAdClicked: (ad) {},
            );
            _isLoaded = true;
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (error) {},
        ),
      );
    }
  }

  loadSaveAd() async {
    bool isConnected = await ConnectivityManager.isConnected();
    if (isConnected) {
      await InterstitialAd.load(
        adUnitId: _adUnit,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            log('[$ad Loaded]');
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {},
              onAdImpression: (ad) {},
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
              },
              onAdDismissedFullScreenContent: (ad) async {
                final bloc = context.read<HomePageBloc>();
                bloc.add(HomePageVideoSaveEvent(videoPath: widget.video));
                ad.dispose();
              },
              onAdClicked: (ad) {},
            );
            // _saveAd = ad;
            ad.show();
          },
          onAdFailedToLoad: (error) {},
        ),
      );
    } else {
      final bloc = context.read<HomePageBloc>();
      bloc.add(HomePageVideoSaveEvent(videoPath: widget.video));
    }
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
                  child: Builder(builder: (context) {
                    if (snapshot.data == null) {
                      return InkWell(
                        onTap: () {
                          bloc.add(HomePageInitialEvent());
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Video doesn\'t exist')));
                        },
                        child: const Icon(
                          FontAwesomeIcons.videoSlash,
                          color: Colors.grey,
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () async {
                        if (_isLoaded) {
                          await _interstitialAd?.show();
                        } else {
                          bloc.add(
                              HomePageVideoNavigateEvent(video: widget.video));
                        }
                      },
                      child: Image.file(
                        File(snapshot.data!),
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            FontAwesomeIcons.videoSlash,
                            color: Colors.grey,
                          );
                        },
                      ),
                    );
                  }),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return InkWell(
                        onTap: () async {
                          if (_isLoaded) {
                            await _interstitialAd?.show();
                          } else {
                            bloc.add(HomePageVideoNavigateEvent(
                                video: widget.video));
                          }
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
                  onTap: () async {
                    loadSaveAd();
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
