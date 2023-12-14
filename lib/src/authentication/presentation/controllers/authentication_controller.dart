
import 'package:riverpod_annotation/riverpod_annotation.dart';




part 'authentication_controller.g.dart';
@riverpod
class AuthenticationController extends _$AuthenticationController {


  // TODO: customize this as you need
  @override
  bool build() => true;
  bool signin() => state = true;
  bool signout() => state = false;
}


