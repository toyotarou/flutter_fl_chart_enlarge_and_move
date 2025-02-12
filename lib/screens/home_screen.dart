import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/graph_manipulator/graph_manipulator.dart';
import 'parts/hold_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final double dataMinX = 0.0;
  final double dataMaxX = 100.0;
  final double dataMinY = 0.0;
  final double dataMaxY = 100.0;

  bool setDataRange = false;

  @override
  Widget build(BuildContext context) {
    if (!setDataRange) {
      // ignore: always_specify_types
      Future(() {
        ref.read(graphManipulatorProvider.notifier).setDataRangeX(dataRangeX: dataMaxX - dataMinX);
        ref.read(graphManipulatorProvider.notifier).setDataRangeY(dataRangeY: dataMaxY - dataMinY);
      });

      setDataRange = true;
    }

    final GraphManipulatorState graphManipulatorState = ref.watch(graphManipulatorProvider);

    final double visibleRangeX = (dataMaxX - dataMinX) / graphManipulatorState.scaleX;
    final double visibleRangeY = (dataMaxY - dataMinY) / graphManipulatorState.scaleY;

    final double minX = graphManipulatorState.offsetX;
    final double maxX = graphManipulatorState.offsetX + visibleRangeX;
    final double minY = graphManipulatorState.offsetY;
    final double maxY = graphManipulatorState.offsetY + visibleRangeY;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Separate Zoom X & Y LineChart'),
      ),
      body: Stack(
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
                        buttonUnitExpansion(),
                        GestureDetector(
                          onTap: () {
                            ref.read(graphManipulatorProvider.notifier).setScaleX(scaleX: 1);
                            ref.read(graphManipulatorProvider.notifier).setScaleY(scaleY: 1);

                            ref.read(graphManipulatorProvider.notifier).setOffsetX(offsetX: dataMinX);
                            ref.read(graphManipulatorProvider.notifier).setOffsetY(offsetY: dataMinY);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                            child: const Icon(Icons.refresh, color: Colors.white),
                          ),
                        ),
                        buttonUnitMove(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget buttonUnitExpansion() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
            GestureDetector(
              onTap: () => expansionVertical(),
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
              onTap: () => reductionHorizontal(),
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
              onTap: () => expansionHorizontal(),
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
              onTap: () => reductionVertical(),
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
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: HoldButton(
                onHold: () => graphMoveToUp(),
                child: const Icon(Icons.arrow_circle_up_outlined, color: Colors.white),
              ),
            ),
            Container(width: 40, height: 40, margin: const EdgeInsets.all(5), padding: const EdgeInsets.all(5)),
          ],
        ),
        Row(
          children: <Widget>[
            HoldButton(
              onHold: () => graphMoveToLeft(),
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
            HoldButton(
              onHold: () => graphMoveToRight(),
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
            HoldButton(
              onHold: () => graphMoveToDown(),
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

  ///
  void expansionVertical() {
    /// 縦方向拡大

    final GraphManipulatorState graphManipulatorState = ref.watch(graphManipulatorProvider);

    final double newScaleY = (graphManipulatorState.scaleY * 2).clamp(1.0, 10.0);
    ref.read(graphManipulatorProvider.notifier).setScaleY(scaleY: newScaleY);

    final double currentVisibleY = graphManipulatorState.dataRangeY / graphManipulatorState.scaleY;
    final double newVisibleY = graphManipulatorState.dataRangeY / newScaleY;
    final double centerY = graphManipulatorState.offsetY + currentVisibleY / 2;
    double newOffsetY = centerY - newVisibleY / 2;
    newOffsetY = newOffsetY.clamp(dataMinY, dataMaxY - newVisibleY);
    ref.read(graphManipulatorProvider.notifier).setOffsetY(offsetY: newOffsetY);
  }

  ///
  void reductionVertical() {
    /// 縦方向縮小

    final GraphManipulatorState graphManipulatorState = ref.watch(graphManipulatorProvider);

    final double newScaleY = (graphManipulatorState.scaleY / 2).clamp(1.0, 10.0);
    ref.read(graphManipulatorProvider.notifier).setScaleY(scaleY: newScaleY);

    final double currentVisibleY = graphManipulatorState.dataRangeY / graphManipulatorState.scaleY;
    final double newVisibleY = graphManipulatorState.dataRangeY / newScaleY;
    final double centerY = graphManipulatorState.offsetY + currentVisibleY / 2;
    double newOffsetY = centerY - newVisibleY / 2;
    newOffsetY = newOffsetY.clamp(dataMinY, dataMaxY - newVisibleY);
    ref.read(graphManipulatorProvider.notifier).setOffsetY(offsetY: newOffsetY);
  }

  ///
  void expansionHorizontal() {
    /// 横方向拡大

    final GraphManipulatorState graphManipulatorState = ref.watch(graphManipulatorProvider);

    final double newScaleX = (graphManipulatorState.scaleX * 2).clamp(1.0, 10.0);
    ref.read(graphManipulatorProvider.notifier).setScaleX(scaleX: newScaleX);

    final double currentVisibleX = graphManipulatorState.dataRangeX / graphManipulatorState.scaleX;
    final double newVisibleX = graphManipulatorState.dataRangeX / newScaleX;
    final double centerX = graphManipulatorState.offsetX + currentVisibleX / 2;
    double newOffsetX = centerX - newVisibleX / 2;
    newOffsetX = newOffsetX.clamp(dataMinX, dataMaxX - newVisibleX);
    ref.read(graphManipulatorProvider.notifier).setOffsetX(offsetX: newOffsetX);
  }

  ///
  void reductionHorizontal() {
    /// 横方向縮小

    final GraphManipulatorState graphManipulatorState = ref.watch(graphManipulatorProvider);

    final double newScaleX = (graphManipulatorState.scaleX / 2).clamp(1.0, 10.0);
    ref.read(graphManipulatorProvider.notifier).setScaleX(scaleX: newScaleX);

    final double currentVisibleX = graphManipulatorState.dataRangeX / graphManipulatorState.scaleX;
    final double newVisibleX = graphManipulatorState.dataRangeX / newScaleX;
    final double centerX = graphManipulatorState.offsetX + currentVisibleX / 2;
    double newOffsetX = centerX - newVisibleX / 2;
    newOffsetX = newOffsetX.clamp(dataMinX, dataMaxX - newVisibleX);
    ref.read(graphManipulatorProvider.notifier).setOffsetX(offsetX: newOffsetX);
  }

  ///
  void graphMoveToUp() {
    final GraphManipulatorState graphManipulatorState = ref.watch(graphManipulatorProvider);

    final double visibleY = graphManipulatorState.dataRangeY / graphManipulatorState.scaleY;
    final double shift = visibleY * 0.1;
    double newOffsetY = graphManipulatorState.offsetY + shift;
    newOffsetY = newOffsetY.clamp(dataMinY, dataMaxY - visibleY);

    ref.read(graphManipulatorProvider.notifier).setOffsetY(offsetY: newOffsetY);
  }

  ///
  void graphMoveToDown() {
    final GraphManipulatorState graphManipulatorState = ref.watch(graphManipulatorProvider);

    final double visibleY = graphManipulatorState.dataRangeY / graphManipulatorState.scaleY;
    final double shift = visibleY * 0.1;
    double newOffsetY = graphManipulatorState.offsetY - shift;
    newOffsetY = newOffsetY.clamp(dataMinY, dataMaxY - visibleY);

    ref.read(graphManipulatorProvider.notifier).setOffsetY(offsetY: newOffsetY);
  }

  ///
  void graphMoveToRight() {
    final GraphManipulatorState graphManipulatorState = ref.watch(graphManipulatorProvider);

    final double visibleX = graphManipulatorState.dataRangeX / graphManipulatorState.scaleX;
    final double shift = visibleX * 0.1;
    double newOffsetX = graphManipulatorState.offsetX + shift;
    newOffsetX = newOffsetX.clamp(dataMinX, dataMaxX - visibleX);

    ref.read(graphManipulatorProvider.notifier).setOffsetX(offsetX: newOffsetX);
  }

  ///
  void graphMoveToLeft() {
    final GraphManipulatorState graphManipulatorState = ref.watch(graphManipulatorProvider);

    final double visibleX = graphManipulatorState.dataRangeX / graphManipulatorState.scaleX;
    final double shift = visibleX * 0.1;
    double newOffsetX = graphManipulatorState.offsetX - shift;
    newOffsetX = newOffsetX.clamp(dataMinX, dataMaxX - visibleX);

    ref.read(graphManipulatorProvider.notifier).setOffsetX(offsetX: newOffsetX);
  }
}
