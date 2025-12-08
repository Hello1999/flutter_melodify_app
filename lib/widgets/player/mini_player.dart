import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/player_provider.dart';
import '../common/cached_image.dart';

class MiniPlayer extends StatelessWidget {
  final VoidCallback? onTap;

  const MiniPlayer({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final song = playerProvider.currentSong;
    final colorScheme = Theme.of(context).colorScheme;

    if (song == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            // 进度条
            LinearProgressIndicator(
              value: playerProvider.progress,
              minHeight: 2,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
            // 播放器内容
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    // 专辑封面
                    AppCachedImage(
                      imageUrl: song.albumArt,
                      width: 48,
                      height: 48,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(width: 12),
                    // 歌曲信息
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            song.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 控制按钮
                    IconButton(
                      icon: Icon(
                        song.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: song.isLiked ? colorScheme.primary : null,
                      ),
                      onPressed: playerProvider.toggleLike,
                    ),
                    IconButton(
                      icon: Icon(
                        playerProvider.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 32,
                      ),
                      onPressed: playerProvider.togglePlayPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded),
                      onPressed: playerProvider.hasNext ? playerProvider.next : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
