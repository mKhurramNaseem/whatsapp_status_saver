import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_events.dart';
import 'package:whatsapp_status_saver/flow/home_page/bloc/home_page_states.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  // Static consts
  static const _statusDirectoryPath =
      '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses';
  // Statuses Directory
  Directory directory = Directory(_statusDirectoryPath);
  // Images & Videos Paths List
  List<FileSystemEntity> statusesList = [];
  List<String> imagesList = [];
  List<String> videosList = [];
  HomePageBloc() : super(HomePageInitialState()) {
    on<HomePageInitialEvent>(_handleInitialEvent);
    on<HomePageImageSaveEvent>(_handleImageSaveEvent);
    on<HomePageVideoSaveEvent>(_handleVideoSaveEvent);
    on<HomePageVideoNavigateEvent>(_handleNavigationEvent);
  }

  FutureOr<void> _handleInitialEvent(
      HomePageInitialEvent event, Emitter<HomePageState> emit) async {
    var status = await Permission.manageExternalStorage.request();
    if (status == PermissionStatus.granted) {
      statusesList = directory.listSync().toList();
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
      emit(const HomePageUpdateState());
    }
  }

  Future<String> getThumbnailFromVideo(String video) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: video,
    );
    return thumbnailPath ?? '';
  }

  FutureOr<void> _handleImageSaveEvent(
      HomePageImageSaveEvent event, Emitter<HomePageState> emit) async {
    await ImageGallerySaver.saveFile(event.imagePath);
    emit(const SavedState(message: 'Image Saved'));
  }

  FutureOr<void> _handleVideoSaveEvent(
      HomePageVideoSaveEvent event, Emitter<HomePageState> emit) async {
    await ImageGallerySaver.saveFile(event.videoPath);
    emit(const SavedState(message: 'Video Saved'));
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
