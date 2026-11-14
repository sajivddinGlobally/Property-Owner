import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/AuthService/AuthServiceProvider.dart';
import '../../../../core/Data/Model/ResponseModel/MarkNotificationReadResModel.dart';

final markMultipleNotificationsReadProvider = FutureProvider.family
    .autoDispose<MarkNotificationReadResModel?, List<String>>((ref, ids) async {
      final service = ref.read(authServiceProvider);
      return await service.markMultipleNotificationsRead(ids: ids);
    });
