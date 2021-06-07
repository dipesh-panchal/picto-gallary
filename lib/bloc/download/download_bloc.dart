import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc() : super(DownloadInitial());

  @override
  Stream<DownloadState> mapEventToState(
    DownloadEvent event,
  ) async* {
    if (event is PhotosDownloadEvent) {
      yield await _mapPhotoDownloadToState(state);

      // print(state);
    }
  }

  Future<DownloadState> _mapPhotoDownloadToState(DownloadState state) async {
    if (!state.isDownloaded) {
      return state.copyWith(isDownloaded: true);
    } else {
      return state.copyWith(isDownloaded: false);
    }
  }
}
