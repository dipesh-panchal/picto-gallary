import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/bridge.dart';

import '/models/photos.dart';
import 'package:http/http.dart' as http;

part 'photos_event.dart';
part 'photos_state.dart';

const _photoLimit = 80;
var pageNum = 1;
const String apiKey = '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';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final http.Client httpClient;
  Bridge bridge = Bridge();
  PhotosBloc({required this.httpClient}) : super(PhotosInitial());

  @override
  Stream<PhotosState> mapEventToState(
    PhotosEvent event,
  ) async* {
    if (event is PhotosFetchedEvent) {
      yield await _mapPhotoFetchedToState(state);
      // print(state);
    }
  }

  Future<PhotosState> _mapPhotoFetchedToState(PhotosState state) async {
    final List<Photos> photos;
    try {
      if (state.photoFetchStatus == PhotosStatus.initial) {
        photos = await _fetchPhotos();
        return state.copyWith(
          photoFetchStatus: PhotosStatus.success,
          photos: photos,
        );
      }
      if (state.photoFetchStatus == PhotosStatus.success &&
          bridge.maxScrollReached == true) {
        pageNum++;
      }
      photos = await _fetchPhotos();
      return state.copyWith(
        photoFetchStatus: PhotosStatus.success,
        photos: List.of(state.photos)..addAll(photos),
      );
    } on Exception {
      return state.copyWith(photoFetchStatus: PhotosStatus.failure);
    }
  }

  Future<List<Photos>> _fetchPhotos() async {
    final response = await http.get(
        Uri.parse(
            'https://api.pexels.com/v1/curated/?page=$pageNum&per_page=$_photoLimit'),
        headers: {"Authorization": "$apiKey"});
    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);
      final parsedPhotoList = (parsedJson["photos"] as List)
          .map((data) => Photos.fromJson(data))
          .toList();
      return parsedPhotoList;
    }
    throw Exception('error fetching posts');
  }
}
