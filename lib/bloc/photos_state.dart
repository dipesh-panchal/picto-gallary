part of 'photos_bloc.dart';

enum PhotosStatus { initial, success, failure }

class PhotosState extends Equatable {
  final List<Photos> photos;
  final photoFetchStatus;
  final bool isDownloaded;

  const PhotosState(
      {this.photoFetchStatus = PhotosStatus.initial,
      this.isDownloaded = false,
      this.photos = const <Photos>[]});

  @override
  List<Object> get props => [photoFetchStatus, photos];
  PhotosState copyWith(
      {PhotosStatus? photoFetchStatus,
      bool? isDownloaded,
      List<Photos>? photos}) {
    return PhotosState(
      photoFetchStatus: photoFetchStatus ?? this.photoFetchStatus,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      photos: photos ?? this.photos,
    );
  }
}

class PhotosInitial extends PhotosState {}

class PhotosLoading extends PhotosState {}

class PhotosFinished extends PhotosState {}
