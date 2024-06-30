import 'package:flutter/material.dart';

@immutable
abstract class HomePageEvent{
  const HomePageEvent();
}

@immutable
class HomePageInitialEvent extends HomePageEvent{}

@immutable
class HomePageImageSaveEvent extends HomePageEvent{
  final String imagePath;
  const HomePageImageSaveEvent({required this.imagePath});
}

@immutable
class HomePageVideoSaveEvent extends HomePageEvent{
  final String videoPath;
  const HomePageVideoSaveEvent({required this.videoPath});
}

@immutable
class HomePageVideoNavigateEvent extends HomePageEvent{
  final String video;
  const HomePageVideoNavigateEvent({required this.video});
}

