import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;

import '/bloc/download/download_bloc.dart';
import '/bloc/photos_bloc.dart';
import '/screen/photos_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              PhotosBloc(httpClient: http.Client())..add(PhotosFetchedEvent()),
        ),
        BlocProvider(
          create: (_) => DownloadBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // routes: {
        //   'FullImage': (context) => FullImage(),
        // },
        home: Wallpaper(),
      ),
    );
  }
}
