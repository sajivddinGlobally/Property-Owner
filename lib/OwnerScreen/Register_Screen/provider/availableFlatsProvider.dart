import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';

final getAvailableFlatsProvider = FutureProvider.autoDispose((ref) async {
  final service = ref.read(authServiceProvider);
  return await service.getAvailableFlats();
});
