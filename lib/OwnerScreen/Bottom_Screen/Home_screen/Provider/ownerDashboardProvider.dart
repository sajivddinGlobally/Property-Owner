import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/ownerDashboardModel.dart';
import 'package:riverpod/riverpod.dart';

final ownerDashboardProvider = FutureProvider.autoDispose<OwnerDashboardModel>((
  ref,
) async {
  final selectedPropertyId = ref.watch(selectedPropertyIdProvider);
  final service = ref.read(authServiceProvider);
  return await service.getOwnerDashboardData(propertyId: selectedPropertyId);
});
