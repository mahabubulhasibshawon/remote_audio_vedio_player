import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

enum VideoPlayerState { stopped, playing, paused, buffering, error }

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerController? _videoController;
  File? _cachedFile;

  VideoPlayerCubit() : super(VideoPlayerState.stopped);

  VideoPlayerController? get controller => _videoController;

  Future<void> loadVideo(String url) async {
    emit(VideoPlayerState.buffering);
    try {
      if (kIsWeb) {
        // On web, use network URL directly
        _videoController = VideoPlayerController.network(url);
      } else {
        // On non-web platforms, use cached file
        final cacheManager = DefaultCacheManager();
        _cachedFile = await cacheManager.getSingleFile(url);
        _videoController = VideoPlayerController.file(_cachedFile!);
      }
      await _videoController!.initialize();
      emit(VideoPlayerState.stopped);
    } catch (e) {
      print("Error loading video: $e");
      emit(VideoPlayerState.error);
    }
  }

  Future<void> play() async {
    await _videoController?.play();
    emit(VideoPlayerState.playing);
  }

  Future<void> pause() async {
    await _videoController?.pause();
    emit(VideoPlayerState.paused);
  }

  Future<void> stop() async {
    await _videoController?.pause();
    await _videoController?.seekTo(Duration.zero);
    emit(VideoPlayerState.stopped);
  }

  Future<void> seek(Duration position) async {
    await _videoController?.seekTo(position);
  }

  @override
  Future<void> close() async {
    await _videoController?.dispose();
    return super.close();
  }
}
