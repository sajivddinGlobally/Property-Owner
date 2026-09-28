import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getTenantPaymentModel.dart' show GetTenantPaymentModel;

final getTenantPaymentProvider = FutureProvider.family
    .autoDispose<GetTenantPaymentModel, String>((ref, id) async {
      final autheservcei = ref.read(authServiceProvider);
      return await autheservcei.getTenantPayment(id: id);
    });
