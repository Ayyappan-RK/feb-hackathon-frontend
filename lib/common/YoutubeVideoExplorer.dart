import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as youtube;

class YoutubeVideoExplorer {
  static Future<String> getVideoUrl(String videoId) async {
    var yt = youtube.YoutubeExplode();
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var streamInfo = manifest.muxed.withHighestBitrate();
    yt.close();
    return streamInfo.url.toString();
  }

  static String? youtubeParser(String url) {
    RegExp regExp = RegExp(
      r'^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*',
    );
    Match? match = regExp.firstMatch(url);
    return (match != null && match.group(7)!.length == 11)
        ? match.group(7)
        : null;
  }

  static getYoutubeCaptions({@required videoURL}) async {
    try {
      final captionScraper = YouTubeCaptionScraper();

// Fetch caption tracks – these are objects containing info like
// base url for the caption track and language code.
      List<CaptionTrack?>? captionTracks =
          await captionScraper.getCaptionTracks(
              videoURL); //'https://youtu.be/Ad_TEk94B9Q?si=Ha6V5Sjv0DzXVf2j'
      if (captionTracks == null) return;
// Fetch the subtitles by providing it with a `CaptionTrack`
// from `getCaptionTracks`.
      final subtitles = await captionScraper.getSubtitles(captionTracks[0]!);

      log(subtitles.join(' '));
      String subtitleFullText = '';
// Use the subtitles however you want.
      for (final subtitle in subtitles) {
        subtitleFullText += subtitle.text;
        // print('${subtitle.start} - ${subtitle.duration} - ${subtitle.text}');
      }
      log(subtitleFullText);
      return subtitleFullText;
    } catch (e) {
      rethrow;
    }
  }
}
