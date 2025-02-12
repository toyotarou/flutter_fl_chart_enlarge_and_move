import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// アプリのルートウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ZoomMoveLineChartPage());
  }
}

class ZoomMoveLineChartPage extends StatefulWidget {
  const ZoomMoveLineChartPage({super.key});

  @override
  State<ZoomMoveLineChartPage> createState() => _ZoomMoveLineChartPageState();
}

class _ZoomMoveLineChartPageState extends State<ZoomMoveLineChartPage> {
  final double _dataMinX = 0.0;
  final double _dataMaxX = 100.0;
  final double _dataMinY = 0.0;
  final double _dataMaxY = 100.0;

  double _scaleX = 1.0;
  double _scaleY = 1.0;

  double _offsetX = 0.0;
  double _offsetY = 0.0;

  // ignore: unused_field
  double _chartWidth = 1.0;

  // ignore: unused_field
  double _chartHeight = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Separate Zoom X & Y LineChart'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          _chartWidth = constraints.maxWidth;
          _chartHeight = constraints.maxHeight;

          final double dataRangeX = _dataMaxX - _dataMinX;
          final double dataRangeY = _dataMaxY - _dataMinY;

          final double visibleRangeX = dataRangeX / _scaleX;
          final double visibleRangeY = dataRangeY / _scaleY;

          final double minX = _offsetX;
          final double maxX = _offsetX + visibleRangeX;
          final double minY = _offsetY;
          final double maxY = _offsetY + visibleRangeY;

          return Stack(
            children: <Widget>[
              LineChart(
                LineChartData(
                  clipData: const FlClipData.all(),
                  minX: minX,
                  maxX: maxX,
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      // ignore: always_specify_types
                      spots: List.generate(101, (int i) {
                        final double x = i.toDouble();
                        final double y = (sin(x * 0.1) * 50) + 50;
                        return FlSpot(x, y);
                      }),
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.blueAccent,
                    ),
                  ],
                  titlesData: const FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                ),
              ),

              //--------------------------------------//

              Positioned(
                bottom: 5,
                right: 5,
                left: 5,
                child: Card(
                  color: Colors.white70,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            buttonUnitEnlarge(),
                            buttonUnitMove(),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  final double newScaleX = (_scaleX * 2).clamp(1.0, 10.0);
                                  final double currentVisibleX = dataRangeX / _scaleX;
                                  final double newVisibleX = dataRangeX / newScaleX;
                                  final double centerX = _offsetX + currentVisibleX / 2;
                                  double newOffsetX = centerX - newVisibleX / 2;
                                  newOffsetX = newOffsetX.clamp(_dataMinX, _dataMaxX - newVisibleX);
                                  _offsetX = newOffsetX;
                                  _scaleX = newScaleX;
                                });
                              },
                              child: const Text('Zoom In X'),
                            ),
                            const SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  final double newScaleX = (_scaleX / 2).clamp(1.0, 10.0);
                                  final double currentVisibleX = dataRangeX / _scaleX;
                                  final double newVisibleX = dataRangeX / newScaleX;
                                  final double centerX = _offsetX + currentVisibleX / 2;
                                  double newOffsetX = centerX - newVisibleX / 2;
                                  newOffsetX = newOffsetX.clamp(_dataMinX, _dataMaxX - newVisibleX);
                                  _offsetX = newOffsetX;
                                  _scaleX = newScaleX;
                                });
                              },
                              child: const Text('Zoom Out X'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  final double newScaleY = (_scaleY * 2).clamp(1.0, 10.0);
                                  final double currentVisibleY = dataRangeY / _scaleY;
                                  final double newVisibleY = dataRangeY / newScaleY;
                                  final double centerY = _offsetY + currentVisibleY / 2;
                                  double newOffsetY = centerY - newVisibleY / 2;
                                  newOffsetY = newOffsetY.clamp(_dataMinY, _dataMaxY - newVisibleY);
                                  _offsetY = newOffsetY;
                                  _scaleY = newScaleY;
                                });
                              },
                              child: const Text('Zoom In Y'),
                            ),
                            const SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  final double newScaleY = (_scaleY / 2).clamp(1.0, 10.0);
                                  final double currentVisibleY = dataRangeY / _scaleY;
                                  final double newVisibleY = dataRangeY / newScaleY;
                                  final double centerY = _offsetY + currentVisibleY / 2;
                                  double newOffsetY = centerY - newVisibleY / 2;
                                  newOffsetY = newOffsetY.clamp(_dataMinY, _dataMaxY - newVisibleY);
                                  _offsetY = newOffsetY;
                                  _scaleY = newScaleY;
                                });
                              },
                              child: const Text('Zoom Out Y'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _scaleX = 1.0;
                              _scaleY = 1.0;
                              _offsetX = _dataMinX;
                              _offsetY = _dataMinY;
                            });
                          },
                          child: const Text('Reset'),
                        ),
                        const Divider(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            HoldButton(
                              onHold: () {
                                setState(() {
                                  final double visibleX = dataRangeX / _scaleX;
                                  final double shift = visibleX * 0.1;
                                  double newOffsetX = _offsetX - shift;
                                  newOffsetX = newOffsetX.clamp(_dataMinX, _dataMaxX - visibleX);
                                  _offsetX = newOffsetX;
                                });
                              },
                              child: const ElevatedButton(onPressed: null, child: Text('←')),
                            ),
                            const SizedBox(width: 4),
                            HoldButton(
                              onHold: () {
                                setState(() {
                                  final double visibleX = dataRangeX / _scaleX;
                                  final double shift = visibleX * 0.1;
                                  double newOffsetX = _offsetX + shift;
                                  newOffsetX = newOffsetX.clamp(_dataMinX, _dataMaxX - visibleX);
                                  _offsetX = newOffsetX;
                                });
                              },
                              child: const ElevatedButton(onPressed: null, child: Text('→')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            HoldButton(
                              onHold: () {
                                setState(() {
                                  final double visibleY = dataRangeY / _scaleY;
                                  final double shift = visibleY * 0.1;
                                  double newOffsetY = _offsetY + shift;
                                  newOffsetY = newOffsetY.clamp(_dataMinY, _dataMaxY - visibleY);
                                  _offsetY = newOffsetY;
                                });
                              },
                              child: const ElevatedButton(onPressed: null, child: Text('↑')),
                            ),
                            const SizedBox(width: 4),
                            HoldButton(
                              onHold: () {
                                setState(() {
                                  final double visibleY = dataRangeY / _scaleY;
                                  final double shift = visibleY * 0.1;
                                  double newOffsetY = _offsetY - shift;
                                  newOffsetY = newOffsetY.clamp(_dataMinY, _dataMaxY - visibleY);
                                  _offsetY = newOffsetY;
                                });
                              },
                              child: const ElevatedButton(onPressed: null, child: Text('↓')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ///
  Widget buttonUnitEnlarge() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: const Text('拡', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
          ],
        ),
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: const Text('縮', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: const Text('拡', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: const Text('縮', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
          ],
        ),
      ],
    );
  }

  ///
  Widget buttonUnitMove() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: const Icon(Icons.arrow_circle_up_outlined, color: Colors.white),
              ),
            ),
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
          ],
        ),
        Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: const Icon(Icons.arrow_circle_left_outlined, color: Colors.white),
              ),
            ),
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: const Icon(Icons.arrow_circle_right_outlined, color: Colors.white),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: const Icon(Icons.arrow_circle_down_outlined, color: Colors.white),
              ),
            ),
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
          ],
        ),
      ],
    );
  }
}

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
