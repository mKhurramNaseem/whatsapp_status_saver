import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_bloc.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_events.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_states.dart';
import 'package:whatsapp_status_saver/flow/home_page/widgets/drawer/app_drawer.dart';
import 'package:whatsapp_status_saver/flow/home_page/widgets/images_part/images_part.dart';
import 'package:whatsapp_status_saver/flow/home_page/widgets/videos_part/videos_part.dart';
import 'package:whatsapp_status_saver/flow/video_view_page/view/video_view_page.dart';
import 'package:whatsapp_status_saver/util/app_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {    
    super.initState();    
  }
  @override
  Widget build(BuildContext context) {    
    final bloc = context.read<HomePageBloc>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{      
      var result = await Permission.storage.request();   
      if(result == PermissionStatus.granted){        
    bloc.add(HomePageInitialEvent());
      }      
    },);    
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Builder(builder: (context) {
        return BlocListener<HomePageBloc, HomePageState>(
          listener: _statesListener,
          child: SafeArea(
            child: Scaffold(
              drawer: const AppDrawer(),
              body: Center(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        title: Text(AppLocalizations.of(context)?.statusSaver ??
                            "Status Saver"),
                        floating: true,
                        pinned: true,
                        toolbarHeight: kToolbarHeight,
                        bottom: TabBar(
                          dividerHeight: kToolbarHeight,
                          tabs: [
                            Tab(
                              child: Text(
                                  AppLocalizations.of(context)?.images ??
                                      'Images'),
                            ),
                            Tab(
                              child: Text(
                                  AppLocalizations.of(context)?.videos ??
                                      'Videos'),
                            ),
                          ],
                        ),
                        actions: [
                          InkWell(
                            onTap: () async {
                              bloc.add(HomePageInitialEvent());
                            },
                            borderRadius: BorderRadius.circular(50.0),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.refresh),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await Share.share(
                                  'Download this app to see your friends status ${AppData.playStoreLink}');
                            },
                            borderRadius: BorderRadius.circular(50.0),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.share),
                            ),
                          ),
                        ],
                      ),
                    ];
                  },
                  body: const TabBarView(
                    children: [
                      ImagesPart(),
                      VideosPart(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _statesListener(BuildContext context, state) {
    if (state is SavedState) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.message)));
    } else if (state is NavigateState) {
      final bloc = context.read<HomePageBloc>();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: bloc,
            child: VideoViewPage(
              temp: state.file,
            ),
          ),
        ),
      );
    } else if (state is ErrorState) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('No Internet'),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }
}
