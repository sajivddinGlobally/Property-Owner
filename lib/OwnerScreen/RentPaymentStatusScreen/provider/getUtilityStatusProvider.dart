import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';

import '../../../core/Data/Model/ResponseModel/gtUtilityStatusModel.dart';

final getUtilityStatusProvider = FutureProvider.family
    .autoDispose<GetUtilityStatusModel, String>((ref, id) async {
      final service = ref.read(authServiceProvider);
      return await service.getUtilityStatus(id: id);
    });
