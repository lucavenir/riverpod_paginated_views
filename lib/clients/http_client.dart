import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';


import 'talker.dart';


part 'http_client.g.dart';
@riverpod
Dio httpClient(HttpClientRef ref) {


  final talker = ref.watch(talkerProvider);

  final options = BaseOptions(
    baseUrl: '$baseUrl/api/v1',  // TODO customize me
    // TODO customize these options
    receiveTimeout: 12.seconds,
    sendTimeout: 12.seconds,
    connectTimeout: 12.seconds,
  );

  final client = Dio(options);

  final loggerInterceptor = TalkerDioLogger(talker: talker);
  client.interceptors.add(loggerInterceptor);

  ref.onDispose(client.close);
  return client;

}




const baseUrl = 'some-url';  // TODO: edit or add custom logic elsewhere, e.g. based on flavors
