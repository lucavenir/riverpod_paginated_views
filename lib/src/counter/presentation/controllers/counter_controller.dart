
import 'package:riverpod_annotation/riverpod_annotation.dart';




part 'counter_controller.g.dart';
@riverpod
class CounterController extends _$CounterController {


  @override
  int build() => 0;
  void increment() => state++;
  void decrement() => state--;
}


