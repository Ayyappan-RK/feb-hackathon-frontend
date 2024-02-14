import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_summary_video_generation/constants/constants.dart';

class TextConversion {
  FlutterTts flutterTts = FlutterTts();
  AudioPlayer audioPlayer = AudioPlayer();
  Future<String> requestSummaryTextFromAI(String userMessage) async {
    final String apiUrl =
        AppConstants.openAIEndpoint; // Adjust URL based on OpenAI API changes

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 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',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': userMessage},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        var summarizedText =
            decodedResponse['choices'][0]['message']['content'];

        // Convert summarized text to audio and save to a file
        await _convertTextToSpeechAndSave(summarizedText);
        return '';
      } else {
        throw Exception("Failed to summary the text");
      }
    } catch (error) {
      throw Exception((error as dynamic).message);
    }
  }

  Future<String> _convertTextToSpeechAndSave(String text) async {
    try {
      // Get the audio file path
      final audioFilePath = await AppConstants.getAudioFilePath();

      // Play the text as speech and save to a file simultaneously
      await flutterTts.setVolume(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.synthesizeToFile(text, audioFilePath);
      return audioFilePath;
      // Play the saved audio file
      await audioPlayer.play(AssetSource(audioFilePath));
      // await audioPlayer.play(audioFilePath, isLocal: true);
    } catch (e) {
      return '';
      print('Error during text-to-speech: $e');
    }
  }
}
