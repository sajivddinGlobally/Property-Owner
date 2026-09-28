import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';

import '../../../core/Data/Model/ResponseModel/getMaintenanceHistoryDetailsModel.dart';

final getMaintenanceHistoryDetailsProvider = FutureProvider.family
    .autoDispose<GetMaintenanceHistoryDetailsModel, String>((ref, id) async {
      final service = ref.read(authServiceProvider);
      return await service.getMaintenanceHistoryDetails(id: id);
    });
