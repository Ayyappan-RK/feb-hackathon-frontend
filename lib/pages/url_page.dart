import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:youtube_summary_video_generation/common/TextConversion.dart';
import 'package:youtube_summary_video_generation/common/VideoProcesor.dart';
import 'package:youtube_summary_video_generation/common/YoutubeVideoExplorer.dart';
import 'package:youtube_summary_video_generation/constants/constants.dart';
import 'package:youtube_summary_video_generation/pages/video_page.dart';
// import 'package:hackathon2/pages/video_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final form = GlobalKey<FormState>();
  var youtubeUrl = "";
  bool isLoading = false;
  String? output;
  int textIndex = 0;
  List<String> loadingTexts = [
    "Fetching Subtitle, Please wait....",
    "Getting Summary for your subtitle...",
    "Analysing video...",
    "Generating video...",
    "video generated..."
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
        String subtitleFullText =
            await YoutubeVideoExplorer.getYoutubeCaptions(videoURL: youtubeUrl);
        setState(() {
          isLoading = true;
          textIndex = 1;
        });
        String audioPath =
            await TextConversion().requestSummaryTextFromAI(subtitleFullText);
        setState(() {
          isLoading = true;
          textIndex = 2;
        });
        final applicationDirectory = await AppConstants.getApplicationDirectory;

        String videoURL = await YoutubeVideoExplorer.getVideoUrl(
            YoutubeVideoExplorer.youtubeParser(youtubeUrl)!);
        setState(() {
          isLoading = true;
          textIndex = 3;
        });
        String downloadVideoPath = await VideoEditor.downloadVideo(videoURL,
            '${applicationDirectory.path}/${AppConstants.generateRandomFileName()}112.mp4');

        File outImages1 = await VideoEditor.generateRandomThumbnail(
          downloadVideoPath,
          '${applicationDirectory.path}/${AppConstants.generateRandomFileName()}112.jpg',
          '00:00:01.000',
        );
        File outImages2 = await VideoEditor.generateRandomThumbnail(
          downloadVideoPath,
          '${applicationDirectory.path}/${AppConstants.generateRandomFileName()}112.jpg',
          '00:00:10.000',
        );
        File outImages3 = await VideoEditor.generateRandomThumbnail(
          downloadVideoPath,
          '${applicationDirectory.path}/${AppConstants.generateRandomFileName()}112.jpg',
          '00:00:15.000',
        );
        File outImages4 = await VideoEditor.generateRandomThumbnail(
          downloadVideoPath,
          '${applicationDirectory.path}/${AppConstants.generateRandomFileName()}112.jpg',
          '00:00:30.000',
        );
        List outImages = [outImages1, outImages2, outImages3, outImages4];
        setState(() {
          isLoading = true;
          textIndex = 4;
        });
        // output = await fetchData(outImages);
        setState(() {
          isLoading = true;
          textIndex = 4;
        });
        // await VideoEditor.uploadGeneratedImage(outImages);
        List outImagesString = outImages.map((e) => e.path).toList();
        String outPath =
            '${applicationDirectory.path}/${AppConstants.generateRandomFileName()}112.mp4';
        String outPath1 =
            '${applicationDirectory.path}/${AppConstants.generateRandomFileName()}1123.mp4';
        await VideoEditor.generateVideoFromSingleImage(
            outImagesString[0], outPath);

        await VideoEditor.generateVideoFromImages(outImagesString, outPath);

        await GallerySaver.saveVideo(outPath1);
        await GallerySaver.saveVideo(outPath);
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

  Future<String> fetchData(outImages) async {
    final jsonData = {
      "template_id": "d82db28b-a430-4ffd-9f5e-5a6726419466",
      "modifications": {
        "Photo 1": outImages[0].path,
        "Photo 2": outImages[1].path,
        "Photo 3": outImages[2].path,
        "Photo 4": outImages[3].path,
        "Photo 5": outImages[3].path,
        "Picture": outImages[3].path
      }
    };

    final response = await http.post(
      Uri.parse('https://api.creatomate.com/v1/renders'),
      headers: {
        'Authorization':
            'Bearer c9d8e3bb0aa045e0a83ed825ff8b64185011f3c0d4f969285ba8f2bd896c412f91ea59c7e767d6aeaf8edbc0dc7c490e',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(jsonData),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
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
                        Text(output ?? ''),
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
