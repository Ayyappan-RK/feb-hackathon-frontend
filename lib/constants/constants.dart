import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';

class AppConstants {
  static String openAIEndpoint = 'https://api.openai.com/v1/chat/completions';
  static String generateRandomFileName({int length = 10}) {
    const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = math.Random();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  static get getApplicationDirectory async =>
      await getApplicationDocumentsDirectory();

  static Future<String> getAudioFilePath() async {
    final directory = await getApplicationDirectory;
    return '${directory.path}/${generateRandomFileName()}.mp3';
  }

  //s3 details
  static Map<String, dynamic> awsS3 = {
    "accessKey": "AKIAV2PNFCOJUVBGQSNC",
    "secretKey": "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"
  };
}
