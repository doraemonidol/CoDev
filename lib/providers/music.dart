import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final assetsAudioPlayer = AssetsAudioPlayer();
List<String> musicList = [];
Future<List<String>> fetchMusicList() async {
  // fetch music list from firebase: in collection 'music', document id '1', field 'list'
  final data =
      await FirebaseFirestore.instance.collection('music').doc('1').get();
  List<String>? musicList = data.data()!['list'].cast<String>();
  if (musicList == null) {
    return [];
  }
  return musicList;
}

void startMusicList() async {
  musicList = await fetchMusicList();
  assetsAudioPlayer.open(
    Playlist(
      audios: musicList
          .map((link) => Audio.network(
                link,
              ))
          .toList(),
    ),
  );
  assetsAudioPlayer.play();
}

void shuffleMusicList(List<String> musicList) {
  musicList.shuffle();
}

void stopMusicList() {
  assetsAudioPlayer.stop();
}

void resumeMusicList() {
  assetsAudioPlayer.play();
}
