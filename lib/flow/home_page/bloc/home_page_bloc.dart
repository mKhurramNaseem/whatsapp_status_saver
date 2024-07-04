import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_events.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_states.dart';
import 'package:whatsapp_status_saver/main.dart';
import 'package:whatsapp_status_saver/util/app_data.dart';
import 'package:whatsapp_status_saver/util/connectivity_manager.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  static const _statusDirectoryPath =
      '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
  static const _statusDirectoryPathLowerVersions = '/storage/emulated/0/WhatsApp/Media/.Statuses';
  static const _businessStatusDirctoryPath =
      '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses';
  static const _businessStatusDirctoryPathLowerVersion =
      '/storage/emulated/0/WhatsApp Business/Media/.Statuses';
  // Statuses Directory
  Directory simpleDirectory = Directory(_statusDirectoryPath);
  Directory businessDirectory = Directory(_businessStatusDirctoryPath);
  Directory simpleDirectoryLowerVersion = Directory(_statusDirectoryPathLowerVersions);
  Directory businessDirectoryLowerVersion = Directory(_businessStatusDirctoryPathLowerVersion);
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // Images & Videos Paths List
  List<FileSystemEntity> statusesList = [];
  List<String> imagesList = [];
  List<String> videosList = [];
  Map<String , String> thumbnails = {};
  HomePageBloc() : super(HomePageInitialState()) {
    on<HomePageInitialEvent>(_handleInitialEvent);
    on<HomePageImageSaveEvent>(_handleImageSaveEvent);
    on<HomePageVideoSaveEvent>(_handleVideoSaveEvent);
    on<HomePageVideoNavigateEvent>(_handleNavigationEvent);
  }

  Future<Directory> getSuitableSimpleDirectory() async{
    var androidInfo = await deviceInfo.androidInfo;
    var release = androidInfo.version.release;    
    if(release == '11' || release == '12' || release == '13' || release == '14'){
      return simpleDirectory;
    }
    return simpleDirectoryLowerVersion;
  }

  Future<Directory> getSuitableBusinessDirectory() async{
    var androidInfo = await deviceInfo.androidInfo;
    var release = androidInfo.version.release;    
    if(release == '11' || release == '12' || release == '13' || release == '14'){
      return businessDirectory;
    }
    return businessDirectoryLowerVersion;
  }

  FutureOr<void> _handleInitialEvent(
      HomePageInitialEvent event, Emitter<HomePageState> emit) async {        
        var isGranted = await Permission.manageExternalStorage.isGranted;
    if (isGranted) {
      if (currentType == WhatsappTypes.simple) {  
        Directory directory = await getSuitableSimpleDirectory();      
        if (directory.existsSync()) {
          statusesList = directory.listSync().toList();
        } else {
          statusesList = [];
          imagesList = [];
          videosList = [];
        }
      } else {        
        Directory directory = await getSuitableBusinessDirectory();
        if (directory.existsSync()) {
          statusesList = directory.listSync().toList();
        } else {
          statusesList = [];
          imagesList = [];
          videosList = [];
        }
      }
      imagesList = statusesList
          .map((e) => e.path)
          .where(
            (element) => element.endsWith('.jpg'),
          )
          .toList();
      videosList = statusesList
          .map(
            (e) => e.path,
          )
          .where(
            (element) => element.endsWith('.mp4'),
          )
          .toList();
      log('Emitting ${imagesList.length} ${videosList.length}');
      emit(HomePageUpdateState());
    }
  }

  Future<String> getThumbnailFromVideo(String video) async {    
    final key = video.split('/').last;
    if(thumbnails.containsKey(key)){
      return Future.value(thumbnails[key]);
    }
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: video,            
    );                
    thumbnails.putIfAbsent(key, () => thumbnailPath ?? '',);
    return thumbnailPath ?? '';
  }

  FutureOr<void> _handleImageSaveEvent(
      HomePageImageSaveEvent event, Emitter<HomePageState> emit) async {
        bool isConnected = await ConnectivityManager.isConnected();
    if(isConnected){
      await ImageGallerySaver.saveFile(event.imagePath);
    emit(SavedState(message: 'Image Saved'));
    }else{
      emit(ErrorState(message: 'Connect to Internet and Try Again!'));
    }
  }

  FutureOr<void> _handleVideoSaveEvent(
      HomePageVideoSaveEvent event, Emitter<HomePageState> emit) async {
    bool isConnected = await ConnectivityManager.isConnected();
    if(isConnected){
     await ImageGallerySaver.saveFile(event.videoPath);
    emit(SavedState(message: 'Video Saved'));         
    }else{
      emit(ErrorState(message: 'Connect to Internet and Try Again!'));
    }
  }

  FutureOr<void> _handleNavigationEvent(
      HomePageVideoNavigateEvent event, Emitter<HomePageState> emit) async {
    File file = File(event.video);
    var directory = await getTemporaryDirectory();
    var temp =
        await file.copy('${directory.path}${Platform.pathSeparator}.temp.mp4');
    emit(NavigateState(file: temp));
  }

  
}
