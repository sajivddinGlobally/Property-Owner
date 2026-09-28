import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getServiceRequestDetailsModel.dart';

final serviceRequestDetailsProvider = FutureProvider.family
    .autoDispose<GetServiceRequestDetailsModel, String>((ref, id) async {
      final service = ref.read(authServiceProvider);
      return await service.getServiceRequestDetails(id: id);
    });
