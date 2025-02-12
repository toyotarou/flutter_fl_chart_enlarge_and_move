import 'dart:async';

import 'package:flutter/material.dart';

///
class HoldButton extends StatefulWidget {
  const HoldButton({
    super.key,
    required this.child,
    required this.onHold,
    this.interval = const Duration(milliseconds: 100),
  });

  final Widget child;
  final VoidCallback onHold;
  final Duration interval;

  @override
  // ignore: library_private_types_in_public_api
  _HoldButtonState createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton> {
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) {
      widget.onHold();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        widget.onHold();

        _startTimer();
      },
      onTapUp: (_) => _stopTimer(),
      onTapCancel: () => _stopTimer(),
      child: widget.child,
    );
  }
}
