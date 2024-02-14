// import 'package:flutter/material.dart';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';
// import 'package:dio/dio.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:youtube_summary_video_generation/common/VideoProcesor.dart';
// import 'package:youtube_summary_video_generation/common/YoutubeVideoExplorer.dart';
// import 'package:youtube_summary_video_generation/constants/constants.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   Future<void> saveVideoToGallery(String videoPath) async {
//     bool? isSaved = await GallerySaver.saveVideo(videoPath);
//     if (isSaved != null && isSaved) {
//       print("Video saved to gallery!");
//     } else {
//       print("Error saving video to gallery.");
//     }
//   }

//   Future<void> _incrementCounter() async {
//     final directory = await AppConstants.getApplicationDirectory;
//     String videoURL = await YoutubeVideoExplorer.getVideoUrl("EngW7tLk6R8");
//     String downloadVideoPath = await VideoEditor.downloadVideo(videoURL,
//         '${directory.path}/${AppConstants.generateRandomFileName()}.mp4');

//     File? thumbnailFile = await VideoEditor.getVideoThumbnail(
//         '${directory.path}/${AppConstants.generateRandomFileName()}.jpg',
//         downloadVideoPath);

//     GallerySaver.saveImage(thumbnailFile!.path!);
//     // return;
//     // Instantiate the scraper.
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
