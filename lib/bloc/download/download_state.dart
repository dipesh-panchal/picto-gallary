part of 'download_bloc.dart';

class DownloadState extends Equatable {
  final bool isDownloaded;
  const DownloadState({this.isDownloaded = false});

  @override
  List<Object> get props => [isDownloaded];
  DownloadState copyWith({
    bool? isDownloaded,
  }) {
    return DownloadState(
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}

class DownloadInitial extends DownloadState {}

class DownloadSuccess extends DownloadState {}
