import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flowder/flowder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_path_provider/android_path_provider.dart';

import '/bloc/download/download_bloc.dart';
import '/bloc/photos_bloc.dart';
import '/screen/ui_component/photo_item_builder.dart';

class Wallpaper extends StatefulWidget {
  @override
  _WallpaperState createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  ScrollController _scrollController = ScrollController();
  late PhotosBloc _photosBloc;
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _photosBloc = context.read<PhotosBloc>();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String picturesPath;
    try {
      picturesPath = await AndroidPathProvider.picturesPath;

      setState(() {
        path = picturesPath;
      });
    } on PlatformException {}

    if (!mounted) return;
  }

  void _onScroll() {
    if (_isBottom) {
      _photosBloc.add(PhotosFetchedEvent());
      _photosBloc.bridge.maxScrollAchieved();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void checkIfDownloaded(int index) {
    if (_photosBloc.state.photos[index].isPhotoDownloaded == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Already Downloaded!')));
      // return
    } else {
      if (_photosBloc.state.photos[index].isPhotoDownloaded == false) {
        _photosBloc.state.photos[index].isPhotoDownloaded = true;
        BlocProvider.of<DownloadBloc>(context).add(PhotosDownloadEvent());
      }
    }
  }

  Future<void> downloadPhoto(int index) async {
    options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
        print('Downloading: $progress');
      },
      file: File('$path/photo[$index].jpg'),
      // file: File(
      //     '${_storageInfo![0].rootDir}/Pictures/AAAAA/photo[$index].jpg'),
      progress: ProgressImplementation(),
      onDone: () => print('COMPLETE, File saved @$path'),
      deleteOnCancel: true,
    );
    core = await Flowder.download(
        _photosBloc.state.photos[index].src!.large2x!, options);
  }

  Future<void> savePhotoToPictures(int index) async {
    try {
      PermissionStatus permission = await Permission.storage.status;

      if (permission != PermissionStatus.granted) {
        await Permission.storage.request();
        PermissionStatus permission = await Permission.storage.status;

        if (permission == PermissionStatus.granted) {
          downloadPhoto(index);
        } else {
          //Retry mechanism
        }
      } else {
        if (permission == PermissionStatus.granted) {
          downloadPhoto(index);
        }
      }
      // print("object");
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _photosBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Center(child: Text('Picto Gallary')),
        elevation: 5.0,
      ),
      body: BlocBuilder<PhotosBloc, PhotosState>(
        builder: (context, state) {
          switch (state.photoFetchStatus) {
            case PhotosStatus.success:
              if (state.photos.isEmpty) {
                return const Center(child: Text('No Photos'));
              } else
                return Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.only(top: 5.0),
                  child: GridView.builder(
                    controller: _scrollController,
                    itemCount: state.photos.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        child: GestureDetector(
                          onTap: () async {
                            checkIfDownloaded(index);
                            savePhotoToPictures(index);
                          },
                          child: PhotoItemBuilder(
                            photosBloc: _photosBloc,
                            index: index,
                          ),
                        ),
                      );
                    },
                  ),
                );
            case PhotosStatus.failure:
              return const Center(child: Text('Failure'));
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
