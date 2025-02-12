import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mixin/graph_manipulator_mixin.dart';
import 'parts/hold_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with GraphManipulatorMixin<HomeScreen> {
  final double dataMinX = 0.0;
  final double dataMaxX = 100.0;
  final double dataMinY = 0.0;
  final double dataMaxY = 100.0;

  bool setDataRange = false;

  @override
  Widget build(BuildContext context) {
    if (!setDataRange) {
      // 初回のみデータレンジを設定
      // ignore: always_specify_types
      Future(() {
        graphNotifier.setDataRangeX(dataRangeX: dataMaxX - dataMinX);
        graphNotifier.setDataRangeY(dataRangeY: dataMaxY - dataMinY);
      });
      setDataRange = true;
    }

    final double visibleRangeX = (dataMaxX - dataMinX) / graphState.scaleX;
    final double visibleRangeY = (dataMaxY - dataMinY) / graphState.scaleY;

    final double minX = graphState.offsetX;
    final double maxX = graphState.offsetX + visibleRangeX;
    final double minY = graphState.offsetY;
    final double maxY = graphState.offsetY + visibleRangeY;

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
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
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
                            // 初期状態にリセット
                            graphNotifier.setScaleX(scaleX: 1);
                            graphNotifier.setScaleY(scaleY: 1);
                            graphNotifier.setOffsetX(offsetX: dataMinX);
                            graphNotifier.setOffsetY(offsetY: dataMinY);
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

  void expansionVertical() {
    // 縦方向拡大
    final double newScaleY = (graphState.scaleY * 2).clamp(1.0, 10.0);
    graphNotifier.setScaleY(scaleY: newScaleY);

    final double currentVisibleY = graphState.dataRangeY / graphState.scaleY;
    final double newVisibleY = graphState.dataRangeY / newScaleY;
    final double centerY = graphState.offsetY + currentVisibleY / 2;
    double newOffsetY = centerY - newVisibleY / 2;
    newOffsetY = newOffsetY.clamp(dataMinY, dataMaxY - newVisibleY);
    graphNotifier.setOffsetY(offsetY: newOffsetY);
  }

  void reductionVertical() {
    // 縦方向縮小
    final double newScaleY = (graphState.scaleY / 2).clamp(1.0, 10.0);
    graphNotifier.setScaleY(scaleY: newScaleY);

    final double currentVisibleY = graphState.dataRangeY / graphState.scaleY;
    final double newVisibleY = graphState.dataRangeY / newScaleY;
    final double centerY = graphState.offsetY + currentVisibleY / 2;
    double newOffsetY = centerY - newVisibleY / 2;
    newOffsetY = newOffsetY.clamp(dataMinY, dataMaxY - newVisibleY);
    graphNotifier.setOffsetY(offsetY: newOffsetY);
  }

  void expansionHorizontal() {
    // 横方向拡大
    final double newScaleX = (graphState.scaleX * 2).clamp(1.0, 10.0);
    graphNotifier.setScaleX(scaleX: newScaleX);

    final double currentVisibleX = graphState.dataRangeX / graphState.scaleX;
    final double newVisibleX = graphState.dataRangeX / newScaleX;
    final double centerX = graphState.offsetX + currentVisibleX / 2;
    double newOffsetX = centerX - newVisibleX / 2;
    newOffsetX = newOffsetX.clamp(dataMinX, dataMaxX - newVisibleX);
    graphNotifier.setOffsetX(offsetX: newOffsetX);
  }

  void reductionHorizontal() {
    // 横方向縮小
    final double newScaleX = (graphState.scaleX / 2).clamp(1.0, 10.0);
    graphNotifier.setScaleX(scaleX: newScaleX);

    final double currentVisibleX = graphState.dataRangeX / graphState.scaleX;
    final double newVisibleX = graphState.dataRangeX / newScaleX;
    final double centerX = graphState.offsetX + currentVisibleX / 2;
    double newOffsetX = centerX - newVisibleX / 2;
    newOffsetX = newOffsetX.clamp(dataMinX, dataMaxX - newVisibleX);
    graphNotifier.setOffsetX(offsetX: newOffsetX);
  }

  void graphMoveToUp() {
    final double visibleY = graphState.dataRangeY / graphState.scaleY;
    final double shift = visibleY * 0.1;
    double newOffsetY = graphState.offsetY + shift;
    newOffsetY = newOffsetY.clamp(dataMinY, dataMaxY - visibleY);
    graphNotifier.setOffsetY(offsetY: newOffsetY); // ※念のため、OffsetX ではなく OffsetY を設定
  }

  void graphMoveToDown() {
    final double visibleY = graphState.dataRangeY / graphState.scaleY;
    final double shift = visibleY * 0.1;
    double newOffsetY = graphState.offsetY - shift;
    newOffsetY = newOffsetY.clamp(dataMinY, dataMaxY - visibleY);
    graphNotifier.setOffsetY(offsetY: newOffsetY);
  }

  void graphMoveToRight() {
    final double visibleX = graphState.dataRangeX / graphState.scaleX;
    final double shift = visibleX * 0.1;
    double newOffsetX = graphState.offsetX + shift;
    newOffsetX = newOffsetX.clamp(dataMinX, dataMaxX - visibleX);
    graphNotifier.setOffsetX(offsetX: newOffsetX);
  }

  void graphMoveToLeft() {
    final double visibleX = graphState.dataRangeX / graphState.scaleX;
    final double shift = visibleX * 0.1;
    double newOffsetX = graphState.offsetX - shift;
    newOffsetX = newOffsetX.clamp(dataMinX, dataMaxX - visibleX);
    graphNotifier.setOffsetX(offsetX: newOffsetX);
  }
}
