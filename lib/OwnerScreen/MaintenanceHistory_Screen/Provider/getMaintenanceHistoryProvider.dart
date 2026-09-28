import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import '../../../core/Data/Model/ResponseModel/getMaintenanceHistoryModel.dart';

final getMaintenanceHistoryProvider = FutureProvider.family
    .autoDispose<GetMaintenanceHistoryModel, String>((ref, filter) async {
      final selectedPropertyId = ref.watch(selectedPropertyIdProvider);
      final service = ref.read(authServiceProvider);
      return await service.maintenanceHistory(
        filter: filter,
        propertyId: selectedPropertyId,
      );
    });
