// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore: depend_on_referenced_packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'graph_manipulator.freezed.dart';

part 'graph_manipulator.g.dart';

@freezed
class GraphManipulatorState with _$GraphManipulatorState {
  const factory GraphManipulatorState({
    @Default(0) double offsetX,
    @Default(0) double offsetY,
    @Default(1) double scaleX,
    @Default(1) double scaleY,
    @Default(0) double dataRangeX,
    @Default(0) double dataRangeY,
  }) = _GraphManipulatorState;
}

@Riverpod(keepAlive: true)
class GraphManipulator extends _$GraphManipulator {
  ///
  @override
  GraphManipulatorState build() => const GraphManipulatorState();

  ///
  void setOffsetX({required double offsetX}) => state = state.copyWith(offsetX: offsetX);

  ///
  void setOffsetY({required double offsetY}) => state = state.copyWith(offsetY: offsetY);

  ///
  void setScaleX({required double scaleX}) => state = state.copyWith(scaleX: scaleX);

  ///
  void setScaleY({required double scaleY}) => state = state.copyWith(scaleY: scaleY);

  ///
  void setDataRangeX({required double dataRangeX}) => state = state.copyWith(dataRangeX: dataRangeX);

  ///
  void setDataRangeY({required double dataRangeY}) => state = state.copyWith(dataRangeY: dataRangeY);
}
