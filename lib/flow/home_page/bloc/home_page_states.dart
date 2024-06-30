import 'dart:io';

import 'package:flutter/material.dart';

@immutable
abstract class HomePageState {
  const HomePageState();
}

@immutable
class HomePageInitialState extends HomePageState {}

@immutable
class HomePageUpdateState extends HomePageState {
  const HomePageUpdateState();
}

@immutable
class SavedState extends HomePageState {
  final String message;
  const SavedState({required this.message});
}

@immutable
class NavigateState extends HomePageState{
  final File file;
  const NavigateState({required this.file});
}