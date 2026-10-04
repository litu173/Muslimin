import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/nav.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/gold_sheet.dart';
import '../../core/widgets/islamic_pattern.dart';
import '../../data/backend/demo_backend.dart';
import '../../data/models/hm.dart';
import '../../data/models/prayer.dart';
import '../../l10n/app_localizations.dart';
import '../../services/time_board_reader.dart';
import '../../state/providers.dart';

final timeBoardReaderProvider = Provider<TimeBoardReader>(
  (ref) => ref.watch(backendProvider) is DemoBackend
      ? DemoTimeBoardReader()
      : GeminiTimeBoardReader(),
);

/// Camera / gallery → photo of the masjid's time board → the times on it.
/// Returns null when the user cancels or nothing could be read.
Future<Map<Prayer, HM>?> scanTimeBoard(BuildContext context) async {
  final t = L10n.of(context);
  final source = await showGoldSheet<ImageSource>(
    context,
    icon: Icons.document_scanner_outlined,
    title: t.scanBoard,
    subtitle: t.scanBoardHint,
    options: [
      GoldSheetOption(ImageSource.camera, t.takePhoto),
      GoldSheetOption(ImageSource.gallery, t.chooseGallery),
    ],
  );
  if (source == null || !context.mounted) return null;
  final XFile? file;
  try {
    file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );
  } catch (_) {
    if (context.mounted) toast(context, t.somethingWrong);
    return null;
  }
  if (file == null || !context.mounted) return null;
  final bytes = await file.readAsBytes();
  if (!context.mounted) return null;
  return Navigator.of(context).push<Map<Prayer, HM>>(
    PageRouteBuilder(
      opaque: true,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, _, _) => TimeBoardScanScreen(image: bytes),
      transitionsBuilder: (_, a, _, child) =>
          FadeTransition(opacity: a, child: child),
    ),
  );
}

/// Full-screen "AI at work" view while the board is being read.
class TimeBoardScanScreen extends ConsumerStatefulWidget {
  const TimeBoardScanScreen({super.key, required this.image});

  final Uint8List image;

  @override
  ConsumerState<TimeBoardScanScreen> createState() =>
      _TimeBoardScanScreenState();
}

class _TimeBoardScanScreenState extends ConsumerState<TimeBoardScanScreen>
    with TickerProviderStateMixin {
  late final _beam = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  )..repeat(reverse: true);
  late final _twinkle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  Timer? _stageTimer;
  int _stage = 0;
  Map<Prayer, HM>? _result;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _stageTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (_result == null && !_failed) {
        setState(() => _stage = (_stage + 1) % 4);
      }
    });
    _run();
  }

  Future<void> _run() async {
    setState(() {
      _failed = false;
      _result = null;
      _stage = 0;
    });
    try {
      final r = await ref.read(timeBoardReaderProvider).read(widget.image);
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      setState(() => _result = r);
      _beam.stop();
      await Future<void>.delayed(const Duration(milliseconds: 1400));
      if (mounted) Navigator.pop(context, r);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    _beam.dispose();
    _twinkle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final f = Fmt.of(context);
    final stages = [t.scanStage1, t.scanStage2, t.scanStage3, t.scanStage4];
    final done = _result != null;
    final status = _failed
        ? t.scanFailed
        : done
        ? t.scanFound(f.digits(_result!.length))
        : stages[_stage];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.header,
        body: IslamicPattern(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Gap.l),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: t.cancel,
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppColors.onHeader,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          t.scanBoard,
                          textAlign: TextAlign.center,
                          style: AppText.subtitle.copyWith(
                            color: AppColors.onHeader,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: Gap.xl),
                  Expanded(
                    child: Center(
                      child: _Viewfinder(
                        image: widget.image,
                        beam: _beam,
                        twinkle: _twinkle,
                        done: done,
                        failed: _failed,
                      ),
                    ),
                  ),
                  const SizedBox(height: Gap.xl),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, a) => FadeTransition(
                      opacity: a,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(a),
                        child: child,
                      ),
                    ),
                    child: Row(
                      key: ValueKey(status),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _failed
                              ? Icons.error_outline_rounded
                              : done
                              ? Icons.check_circle_rounded
                              : Icons.auto_awesome_rounded,
                          color: _failed
                              ? AppColors.onHeader
                              : AppColors.goldLight,
                          size: 20,
                        ),
                        const SizedBox(width: Gap.s),
                        Flexible(
                          child: Text(
                            status,
                            textAlign: TextAlign.center,
                            style: AppText.label.copyWith(
                              color: AppColors.onHeader,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Gap.m),
                  if (done)
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: Gap.s,
                      runSpacing: Gap.s,
                      children: [
                        for (final p in Prayer.values)
                          if (_result![p] case final hm?)
                            _ResultChip('${f.prayer(p)} ${f.hm(hm)}'),
                      ],
                    )
                  else if (_failed)
                    ButtonPair(
                      secondary: AppButton(
                        t.enterManually,
                        style: AppButtonStyle.darkOutlined,
                        onPressed: () => Navigator.pop(context),
                      ),
                      primary: AppButton(t.retry, onPressed: _run),
                    )
                  else
                    _ThinkingDots(animation: _twinkle),
                  const SizedBox(height: Gap.l),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultChip extends StatelessWidget {
  const _ResultChip(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeOutBack,
    builder: (_, v, child) => Transform.scale(scale: v, child: child),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.goldLight.withValues(alpha: 0.16),
        border: Border.all(color: AppColors.goldLight.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        text,
        style: AppText.caption.copyWith(color: AppColors.goldLight),
      ),
    ),
  );
}

/// Photo in a gold viewfinder with a sweeping scan beam and twinkling
/// sparkles; turns into a soft gold glow when the reading is done.
class _Viewfinder extends StatelessWidget {
  const _Viewfinder({
    required this.image,
    required this.beam,
    required this.twinkle,
    required this.done,
    required this.failed,
  });

  final Uint8List image;
  final Animation<double> beam;
  final Animation<double> twinkle;
  final bool done;
  final bool failed;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 3 / 4,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldLight.withValues(alpha: done ? 0.55 : 0.18),
            blurRadius: done ? 40 : 24,
            spreadRadius: done ? 2 : 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(image, fit: BoxFit.cover),
            // Slight dim so the beam reads well on bright LED boards.
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              color: Colors.black.withValues(alpha: done ? 0.05 : 0.28),
            ),
            if (!done && !failed)
              AnimatedBuilder(
                animation: beam,
                builder: (_, _) => CustomPaint(
                  painter: _BeamPainter(Curves.easeInOut.transform(beam.value)),
                ),
              ),
            if (!failed)
              AnimatedBuilder(
                animation: twinkle,
                builder: (_, _) => CustomPaint(
                  painter: _SparklePainter(twinkle.value, done: done),
                ),
              ),
            const CustomPaint(painter: _CornersPainter()),
          ],
        ),
      ),
    ),
  );
}

class _BeamPainter extends CustomPainter {
  _BeamPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * (0.06 + 0.88 * t);
    // Soft trail.
    final trail = Rect.fromLTWH(0, y - 90, size.width, 90);
    canvas.drawRect(
      trail,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0x00FFC940),
            const Color(0xFFFFC940).withValues(alpha: 0.28),
          ],
        ).createShader(trail),
    );
    // Bright line with glow.
    final line = Paint()
      ..color = const Color(0xFFFFE08A)
      ..strokeWidth = 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 6);
    canvas.drawLine(Offset(12, y), Offset(size.width - 12, y), line);
  }

  @override
  bool shouldRepaint(_BeamPainter old) => old.t != t;
}

class _SparklePainter extends CustomPainter {
  _SparklePainter(this.t, {required this.done});
  final double t;
  final bool done;

  static final _spots = List.generate(9, (i) {
    final r = math.Random(i * 31 + 7);
    return (
      r.nextDouble(),
      r.nextDouble(),
      r.nextDouble(),
      5 + r.nextDouble() * 7,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final (x, y, phase, s) in _spots) {
      final v = math.sin(((t + phase) % 1) * math.pi); // 0→1→0
      final a = (done ? 0.9 : 0.75) * v;
      if (a < 0.05) continue;
      final c = Offset(x * size.width, y * size.height);
      final r = s * (0.6 + 0.4 * v) * (done ? 1.2 : 1);
      final p = Paint()..color = const Color(0xFFFFE08A).withValues(alpha: a);
      // Four-point star.
      final path = Path()
        ..moveTo(c.dx, c.dy - r)
        ..quadraticBezierTo(c.dx, c.dy, c.dx + r, c.dy)
        ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + r)
        ..quadraticBezierTo(c.dx, c.dy, c.dx - r, c.dy)
        ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - r)
        ..close();
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(_SparklePainter old) => old.t != t || old.done != done;
}

class _CornersPainter extends CustomPainter {
  const _CornersPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const l = 28.0, inset = 14.0;
    final p = Paint()
      ..color = const Color(0xFFFFC940)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final w = size.width, h = size.height;
    for (final (x, y, dx, dy) in [
      (inset, inset, 1.0, 1.0),
      (w - inset, inset, -1.0, 1.0),
      (inset, h - inset, 1.0, -1.0),
      (w - inset, h - inset, -1.0, -1.0),
    ]) {
      canvas.drawPath(
        Path()
          ..moveTo(x, y + dy * l)
          ..lineTo(x, y)
          ..lineTo(x + dx * l, y),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_CornersPainter old) => false;
}

class _ThinkingDots extends StatelessWidget {
  const _ThinkingDots({required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder: (_, _) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.goldLight.withValues(
                alpha:
                    0.3 +
                    0.7 *
                        math.sin(((animation.value * 2 + i / 3) % 1) * math.pi),
              ),
            ),
          ),
      ],
    ),
  );
}
