import 'dart:io';
import 'package:mime/mime.dart';
import 'package:aws_s3_client/aws_s3_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:youtube_summary_video_generation/constants/constants.dart';

class VideoEditor {
  static Future<String> downloadVideo(String url, String savePath) async {
    var dio = Dio();
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        // The DioOptions should prevent issues with content length checks.
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file.path;
    } catch (e) {
      return '';
    }
  }

  static void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  static Future<File?> getVideoThumbnail(
      String outPath, String url, String frame) async {
    final arguments = [
      '-i',
      url,
      '-ss',
      frame,
      '-vframes',
      '1',
      '-q:v',
      '50',
      outPath
    ];

    final flutterFFmpeg = FlutterFFmpeg();
    final execution = await flutterFFmpeg.executeWithArguments(arguments);
    if (execution == 0) {
      return File(outPath);
    } else {
      print('Error extracting video thumbnail');
      return null;
    }
  }

  static uploadGeneratedImage(List files) async {
    List output = [];
    for (File file in files) {
      var outImage = await uploadFile(
          file, file.path.split('/')[file.path.split('/').length - 1]);
      output.add(outImage);
    }
    return output;
  }

  static Future<String> uploadFile(File file, String fileName) async {
    const region = "eu-west-2";
    const bucketName = "mythings-dev";
    Spaces spaces = Spaces(
        region: region,
        accessKey: AppConstants.awsS3["accessKey"],
        secretKey: AppConstants.awsS3["secretKey"]);

    Bucket bucket = spaces.bucket(bucketName);

    String? mimeType = lookupMimeType(file.path);
    String uploadedImageUrl = await bucket.uploadFile(
        fileName, file.readAsBytesSync(), mimeType, Permissions.public);
    return uploadedImageUrl;
  }

  static final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  static final FlutterFFmpegConfig _flutterFFmpegConfig = FlutterFFmpegConfig();

  static Future<void> generateVideoFromSingleImage(
      String imagePath, String outputPath) async {
    // Simplified FFmpeg command to create a short video from a single image
    String ffmpegCommand =
        "-loop 1 -t 5 -i \"$imagePath\" -c:v libx264 -vf \"fps=25,format=yuv420p\" \"$outputPath\"";

    // Enable FFmpeg log and print it
    _flutterFFmpegConfig.enableLogCallback((log) => print(log.message));

    // Execute the FFmpeg command
    int rc = await _flutterFFmpeg.execute(ffmpegCommand);
    if (rc == 0) {
      print("Video generated successfully");
    } else {
      print("Failed to generate video. Error code: $rc");
    }
  }

  static Future<List> generateRandomThumbnail(
      downloadVideoPath, filename, frame) async {
    File? thumbnailFile =
        await VideoEditor.getVideoThumbnail(filename, downloadVideoPath, frame);
    return [thumbnailFile];
  }

  static generateVideo() {}

  static Future<void> generateVideoFromImages(
      List imagePaths, String outputPath) async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

    // Assuming images are sequentially named and located in the same directory
    // Example pattern: /path/to/images/img%03d.jpg (for img001.jpg, img002.jpg, etc.)
    // Adjust the pattern according to your actual image file names and paths
    String imagePattern =
        imagePaths.first.replaceAll(RegExp(r'(\d+)(\.\w+)$'), '%03d\$2');

    // FFmpeg command to create a video from a sequence of images
    // -framerate specifies the number of frames (images) per second in the output video
    // Adjust the framerate as needed
    String ffmpegCommand =
        "-framerate 1 -i $imagePattern -c:v libx264 -pix_fmt yuv420p $outputPath";

    // Execute the FFmpeg command
    int rc = await _flutterFFmpeg.execute(ffmpegCommand);
    if (rc == 0) {
      print("Video generated successfully");
    } else {
      print("Failed to generate video. Error code: $rc");
    }
  }
}
