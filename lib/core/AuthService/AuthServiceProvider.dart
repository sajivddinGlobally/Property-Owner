import 'package:dio/dio.dart';
import 'package:property_care/core/AuthService/AuthService.dart';
import 'package:property_care/core/Network/ApiStateNetwork.dart';
import 'package:property_care/core/Utils/preety.dio.dart';
import 'package:riverpod/riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return createDio();
});

final apiProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return ApiStateNetwork(dio);
});

final authServiceProvider = Provider((ref) {
  final api = ref.read(apiProvider);
  return AuthService(api);
});
