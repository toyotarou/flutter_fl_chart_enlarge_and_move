// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/graph_manipulator/graph_manipulator.dart';

mixin GraphManipulatorMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  GraphManipulatorState get graphState => ref.watch(graphManipulatorProvider);

  GraphManipulator get graphNotifier => ref.read(graphManipulatorProvider.notifier);
}
