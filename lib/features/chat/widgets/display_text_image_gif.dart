import "package:flutter/material.dart";
import "package:whatslynxing/common/enums/message_enum.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:whatslynxing/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF(
      {super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : CachedNetworkImage(
                imageUrl: message,
              );
  }
}
