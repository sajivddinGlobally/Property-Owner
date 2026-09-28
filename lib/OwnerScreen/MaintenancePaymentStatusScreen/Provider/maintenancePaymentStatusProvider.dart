import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart'
    show selectedPropertyIdProvider;
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/maintenancePaymentStatusModel.dart';
import 'package:riverpod/riverpod.dart';

final maintenancePaymentStatusProvider =
    FutureProvider.autoDispose<MaintenancePaymentStatusModel>((ref) async {
      final selectedPropertyId = ref.watch(selectedPropertyIdProvider);
      final service = ref.read(authServiceProvider);
      return await service.maintenancePaymentStatus(
        propertyId: selectedPropertyId,
      );
    });
