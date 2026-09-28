import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/documentDetialsModel.dart';

final documentDetailsProvider = FutureProvider.family
    .autoDispose<DocumentDetailsModel, String>((ref, id) async {
      final servcie = ref.read(authServiceProvider);
      return await servcie.documentDetails(id: id);
    });
