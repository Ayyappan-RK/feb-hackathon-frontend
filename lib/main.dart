import 'package:flutter/material.dart';
import 'package:youtube_summary_video_generation/pages/homepage.dart';
import 'package:youtube_summary_video_generation/pages/url_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Video Summary',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:video_generator/video_generator.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: GenerateVideoScreen(),
//     );
//   }
// }

// class GenerateVideoScreen extends StatelessWidget {
//   List<String> imagePaths = [
//     'path/to/image1.jpg',
//     'path/to/image2.jpg',
//     // Add more image paths as needed
//   ];

//   String outputPath = 'path/to/output/video.mp4';

//   Future<void> generateVideoFromImages(
//       List<String> imagePaths, String outputPath) async {
//     final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

//     // Construct the FFmpeg command to combine images into a video
//     // This example assumes images are named in a sequence (e.g., img1.jpg, img2.jpg, etc.)
//     // and uses a frame rate of 1 image per second
//     String inputFiles = imagePaths.map((path) => "-i $path").join(" ");
//     String ffmpegCommand =
//         "$inputFiles -filter_complex \"concat=n=${imagePaths.length}:v=1:a=0 [v]\" -map \"[v]\" $outputPath";

//     // Execute the FFmpeg command
//     int rc = await _flutterFFmpeg.execute(ffmpegCommand);
//     if (rc == 0) {
//       print("Video generated successfully");
//     } else {
//       print("Failed to generate video");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Generate Video'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             generateVideoFromImages(imagePaths, outputPath);
//           },
//           child: Text('Generate Video'),
//         ),
//       ),
//     );
//   }
// }
