import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';

/// Row of single-digit OTP boxes backed by one hidden text field, so paste
/// and SMS autofill (iOS one-time-code / Android) work naturally.
class OtpBoxes extends StatefulWidget {
  const OtpBoxes({super.key, this.length = 6, required this.onCompleted});

  final int length;
  final ValueChanged<String> onCompleted;

  @override
  State<OtpBoxes> createState() => OtpBoxesState();
}

class OtpBoxesState extends State<OtpBoxes> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  String get code => _controller.text;

  void clear() {
    _controller.clear();
    setState(() {});
    _focus.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => _focus.requestFocus(),
    child: Stack(
      children: [
        Opacity(
          opacity: 0,
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(widget.length),
            ],
            onChanged: (v) {
              setState(() {});
              if (v.length == widget.length) widget.onCompleted(v);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < widget.length; i++)
              Container(
                width: 44,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(Radii.field),
                  border: Border.all(
                    color: i == _controller.text.length && _focus.hasFocus
                        ? AppColors.gold
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  i < _controller.text.length ? _controller.text[i] : '',
                  style: AppText.subtitle,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
