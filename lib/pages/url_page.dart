import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:youtube_summary_video_generation/common/VideoProcesor.dart';
import 'package:youtube_summary_video_generation/common/YoutubeVideoExplorer.dart';
import 'package:youtube_summary_video_generation/constants/constants.dart';
import 'package:youtube_summary_video_generation/pages/video_page.dart';
// import 'package:hackathon2/pages/video_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final form = GlobalKey<FormState>();
  var youtubeUrl = "";
  bool isLoading = false;
  int textIndex = 0;
  List<String> loadingTexts = [
    "Fetching Subtitle, Please wait....",
    "Loading",
    "Please wait",
    "Almost there"
  ];

  Timer? _timer;

  Future<void> simulateLoading() async {
    // Simulate some asynchronous operation
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> submit() async {
    final isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
      setState(() {
        isLoading = true;
        textIndex = 0;
      });
      try {
        await YoutubeVideoExplorer.getYoutubeCaptions(videoURL: youtubeUrl);
        final applicationDirectory = await AppConstants.getApplicationDirectory;
        print(YoutubeVideoExplorer.youtubeParser(youtubeUrl));
        String videoURL = await YoutubeVideoExplorer.getVideoUrl("EngW7tLk6R8");
        String downloadVideoPath = await VideoEditor.downloadVideo(videoURL,
            '${applicationDirectory.path}/${AppConstants.generateRandomFileName()}112.mp4');

        List outImages = await VideoEditor.generateRandomThumbnail(
            downloadVideoPath,
            '${applicationDirectory.path}/${AppConstants.generateRandomFileName()}112.jpg');
        await Future.delayed(Duration(seconds: 2));

        await GallerySaver.saveImage(outImages[0].path);
        await Future.delayed(Duration(seconds: 2));
        // await VideoEditor.uploadGeneratedImage(outImages);
        List outImagesString = outImages.map((e) => e.path).toList();
        String outPath =
            '${applicationDirectory.path}/${AppConstants.generateRandomFileName()}112.mp4';
        await VideoEditor.generateVideoFromSingleImage(
            outImagesString[0], outPath);

        await VideoEditor.generateVideoFromImages(outImagesString, outPath);

        // GallerySaver.saveVideo(outPath);
        setState(() {
          isLoading = false;
          textIndex = 0;
        });
        print(outImages);
      } catch (e) {
        setState(() {
          isLoading = false;
          textIndex = 0;
        });
        throw Exception(e);
      }
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 4.0,
        title: const Text("Hackathon 2!"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Form(
                  key: form,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: "URL"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a valid URL";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          debugPrint(value);
                          youtubeUrl = value!;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                        onPressed: isLoading ? null : submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: LinearProgressIndicator(),
                              )
                            : const Text("Submit"),
                      ),
                      if (isLoading) const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(loadingTexts[textIndex]),
                        const SizedBox(height: 8),
                        const LinearProgressIndicator(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
