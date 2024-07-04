import 'dart:io';

import 'package:flutter/material.dart';

@immutable
abstract class HomePageState {
  
}

@immutable
class HomePageInitialState extends HomePageState {}

@immutable
class HomePageUpdateState extends HomePageState {
  HomePageUpdateState();
}


@immutable
class SavedState extends HomePageState {
  final String message;
  SavedState({required this.message});
}

@immutable
class NavigateState extends HomePageState{
  final File file;
  NavigateState({required this.file});
}

class ErrorState extends HomePageState{
  final String message;
  ErrorState({required this.message});
}