import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../core/nav.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/models/channel.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/providers.dart';

/// "3.4 MB"
String fileSize(int bytes) => bytes < 1024 * 1024
    ? '${(bytes / 1024).ceil()} KB'
    : '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';

/// Bytes of a message's attachment, downloaded once per session.
/// Keyed by (masjid id, message id, chunk count).
final attachmentBytesProvider =
    FutureProvider.family<Uint8List, (String, String, int)>(
      (ref, k) => ref.read(backendProvider).channelAttachment(k.$1, k.$2, k.$3),
    );

/// The attachment written to a temp file (players and "open" need a path).
Future<File> attachmentFile(ChannelMessage m, Uint8List bytes) async {
  // One folder per message keeps the original file name for viewers and
  // "Save to Files".
  final dir = Directory('${(await getTemporaryDirectory()).path}/ch_${m.id}');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  final safe = m.attachment!.name.replaceAll(RegExp(r'[/\\:]'), '_');
  final f = File('${dir.path}/$safe');
  if (!f.existsSync() || f.lengthSync() != bytes.length) {
    await f.writeAsBytes(bytes, flush: true);
  }
  return f;
}

/// An attachment inside a channel message.
class AttachmentView extends ConsumerWidget {
  const AttachmentView({super.key, required this.masjidId, required this.m});

  final String masjidId;
  final ChannelMessage m;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = m.attachment!;
    final t = L10n.of(context);
    final key = (masjidId, m.id, a.chunks);
    final bytes = ref.watch(attachmentBytesProvider(key));

    if (a.kind == AttachmentKind.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Radii.button),
        child: bytes.when(
          loading: () => _box(const CircularProgressIndicator(strokeWidth: 2)),
          error: (_, _) =>
              _box(Icon(Icons.broken_image_outlined, color: AppColors.muted)),
          data: (b) => GestureDetector(
            onTap: () => push(context, _ImageScreen(bytes: b)),
            child: Image.memory(b, fit: BoxFit.cover, width: double.infinity),
          ),
        ),
      );
    }

    final (icon, label) = switch (a.kind) {
      AttachmentKind.video => (Icons.play_circle_fill_rounded, t.attachVideo),
      AttachmentKind.audio => (Icons.graphic_eq_rounded, t.attachAudio),
      _ => (Icons.insert_drive_file_rounded, t.attachFile),
    };

    Future<void> open() async {
      final b = bytes.value;
      if (b == null) return;
      final f = await attachmentFile(m, b);
      if (!context.mounted) return;
      switch (a.kind) {
        case AttachmentKind.video:
          push(context, _VideoScreen(file: f));
        case AttachmentKind.audio:
          await showModalBottomSheet<void>(
            context: context,
            backgroundColor: AppColors.card,
            builder: (_) => _AudioSheet(file: f, name: a.name),
          );
        default:
          final r = await OpenFilex.open(f.path);
          if (r.type != ResultType.done && context.mounted) {
            toast(context, t.cantOpenFile);
          }
      }
    }

    return Material(
      color: AppColors.gold.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(Radii.button),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.button),
        onTap: bytes.hasValue ? open : null,
        child: Padding(
          padding: const EdgeInsets.all(Gap.m),
          child: Row(
            children: [
              Icon(icon, color: AppColors.gold, size: 34),
              const SizedBox(width: Gap.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label,
                    ),
                    Text(
                      '$label · ${fileSize(a.size)}',
                      style: AppText.micro.copyWith(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              if (bytes.isLoading)
                const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (bytes.hasError)
                IconButton(
                  icon: Icon(Icons.refresh_rounded, color: AppColors.muted),
                  onPressed: () => ref.invalidate(attachmentBytesProvider(key)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box(Widget child) => Container(
    height: 180,
    color: AppColors.gold.withValues(alpha: 0.08),
    alignment: Alignment.center,
    child: child,
  );
}

class _ImageScreen extends StatelessWidget {
  const _ImageScreen({required this.bytes});
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    body: InteractiveViewer(child: Center(child: Image.memory(bytes))),
  );
}

class _VideoScreen extends StatefulWidget {
  const _VideoScreen({required this.file});
  final File file;

  @override
  State<_VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<_VideoScreen> {
  late final _c = VideoPlayerController.file(widget.file);

  @override
  void initState() {
    super.initState();
    _c.initialize().then((_) {
      if (mounted) setState(() {});
      _c.play();
    });
    _c.addListener(() => mounted ? setState(() {}) : null);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    body: Center(
      child: !_c.value.isInitialized
          ? const CircularProgressIndicator()
          : GestureDetector(
              onTap: () => _c.value.isPlaying ? _c.pause() : _c.play(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _c.value.aspectRatio,
                    child: VideoPlayer(_c),
                  ),
                  if (!_c.value.isPlaying)
                    const Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white70,
                      size: 72,
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: VideoProgressIndicator(_c, allowScrubbing: true),
                  ),
                ],
              ),
            ),
    ),
  );
}

class _AudioSheet extends StatefulWidget {
  const _AudioSheet({required this.file, required this.name});
  final File file;
  final String name;

  @override
  State<_AudioSheet> createState() => _AudioSheetState();
}

class _AudioSheetState extends State<_AudioSheet> {
  final _p = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _p.setFilePath(widget.file.path).then((_) => _p.play());
  }

  @override
  void dispose() {
    _p.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(Gap.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.name, style: AppText.label, textAlign: TextAlign.center),
          const SizedBox(height: Gap.l),
          StreamBuilder<Duration>(
            stream: _p.positionStream,
            builder: (_, snap) {
              final pos = snap.data ?? Duration.zero;
              final total = _p.duration ?? Duration.zero;
              return Slider(
                activeColor: AppColors.gold,
                value: total.inMilliseconds == 0
                    ? 0
                    : (pos.inMilliseconds / total.inMilliseconds).clamp(0, 1),
                onChanged: (v) => _p.seek(total * v),
              );
            },
          ),
          StreamBuilder<PlayerState>(
            stream: _p.playerStateStream,
            builder: (_, snap) {
              final playing = snap.data?.playing ?? false;
              return IconButton.filled(
                iconSize: 36,
                style: IconButton.styleFrom(backgroundColor: AppColors.gold),
                onPressed: () => playing ? _p.pause() : _p.play(),
                icon: Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
