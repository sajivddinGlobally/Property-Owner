import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getTenantDetailsModel.dart';

final getTenantDetailsProvider = FutureProvider.family
    .autoDispose<GetTenantDetailsModel, String>((ref, id) {
      final selectedPropertyId = ref.watch(selectedPropertyIdProvider);
      final authService = ref.watch(authServiceProvider);
      return authService.getTenantDetails(
        id: id,
        propertyId: selectedPropertyId,
      );
    });
