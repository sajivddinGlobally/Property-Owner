import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getInpectoinReportDetailsModel.dart';

final getInspectionReportDetailsProvider =
    FutureProvider.family.autoDispose<GetInspectionReportDetailsModel, String>((
      ref,
      id,
    ) async {
      final authService = ref.watch(authServiceProvider);
      return authService.getInspectionReportDetails(id: id);
    });
