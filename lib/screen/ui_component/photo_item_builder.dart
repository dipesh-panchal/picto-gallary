import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/download/download_bloc.dart';
import '/bloc/photos_bloc.dart';

class PhotoItemBuilder extends StatelessWidget {
  const PhotoItemBuilder({Key? key, required PhotosBloc photosBloc, index})
      : _photosBloc = photosBloc,
        _index = index,
        super(key: key);

  final PhotosBloc _photosBloc;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image: NetworkImage(
                _photosBloc.state.photos[_index].src!.tiny!,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        BlocBuilder<DownloadBloc, DownloadState>(
          builder: (context, state) {
            if (_photosBloc.state.photos[_index].isPhotoDownloaded == true) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
              );
            } else
              return Container();
          },
        ),
      ],
    );
  }
}
