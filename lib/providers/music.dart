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
  print('music list fetched');
  for (int i = 0; i < 5; i++) print(i);
  print(await musicList);
  for (int i = 6; i < 10; i++) print(i);
  shuffleMusicList(musicList);
  await assetsAudioPlayer.open(
    Playlist(
      audios: await musicList
          .map((link) => Audio.network(
                link,
              ))
          .toList(),
    ),
  );
  await assetsAudioPlayer.play();
  print('music list started');
}

void shuffleMusicList(List<String> musicList) {
  musicList.shuffle();
}

void stopMusicList() async {
  await assetsAudioPlayer.stop();
}

void resumeMusicList() async {
  await assetsAudioPlayer.play();
}

void muteMusicList() async {
  await assetsAudioPlayer.setVolume(0);
}

void unmuteMusicList() async {
  await assetsAudioPlayer.setVolume(1);
}
