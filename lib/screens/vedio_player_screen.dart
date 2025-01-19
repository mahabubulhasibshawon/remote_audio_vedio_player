import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../cubit/vedio_player_cubit.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl =
      "https://www.rmp-streaming.com/media/big-buck-bunny-360p.mp4";
  final String posterUrl =
      "https://as2.ftcdn.net/v2/jpg/05/89/42/47/1000_F_589424794_bNVIYhyC0csLgCNJm6FV8PJrXa1PeSfm.jpg";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VideoPlayerCubit()..loadVideo(videoUrl),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Video Player with Cache and Poster"),
        ),
        body: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
          builder: (context, state) {
            final cubit = context.read<VideoPlayerCubit>();
            final controller = cubit.controller;

            return Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Poster Image
                    if (state == VideoPlayerState.stopped ||
                        state == VideoPlayerState.buffering)
                      Image.network(
                        posterUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    // Video Player
                    if (controller != null && controller.value.isInitialized)
                      AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      ),
                    // Loading Indicator
                    if (state == VideoPlayerState.buffering)
                      CircularProgressIndicator(),
                  ],
                ),
                if (controller != null && controller.value.isInitialized)
                  Column(
                    children: [
                      Slider(
                        min: 0,
                        max: controller.value.duration.inMilliseconds.toDouble(),
                        value: controller.value.position.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          cubit.seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      Text(
                        "${controller.value.position.inMinutes}:${(controller.value.position.inSeconds % 60).toString().padLeft(2, '0')} / "
                            "${controller.value.duration.inMinutes}:${(controller.value.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        state == VideoPlayerState.playing
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        if (state == VideoPlayerState.playing) {
                          cubit.pause();
                        } else {
                          cubit.play();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.stop, size: 40, color: Colors.red),
                      onPressed: cubit.stop,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
