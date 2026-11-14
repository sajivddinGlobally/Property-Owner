import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getPropertyScoreModel.dart';

/// Score Trend period: day | week | month | year (Home Care). Default month.
final propertyScorePeriodProvider = StateProvider.autoDispose<String>(
  (ref) => "month",
);

final getPropertyScoreProvider =
    FutureProvider.autoDispose<GetPropertyScoreModel>((ref) async {
      final selectedPropertyId = ref.watch(selectedPropertyIdProvider);
      final period = ref.watch(propertyScorePeriodProvider);
      final service = ref.read(authServiceProvider);
      return await service.getPropertyScore(
        propertyId: selectedPropertyId,
        period: period,
      );
    });
