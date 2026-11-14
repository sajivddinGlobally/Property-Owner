import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getNotificaionListModel.dart';

import 'selectedPropertyProvider.dart';

// final getNotificaionListProvider = FutureProvider.family
//     .autoDispose<GetNotificaionListModel, String>((ref, filter) async {
//       final service = ref.read(authServiceProvider);
//       return await service.getNotificaionList(filter: filter,);
//     });

final getNotificaionListProvider = FutureProvider.family
    .autoDispose<GetNotificaionListModel, String>((ref, filter) async {
      // Selected property ki notifications (property badle to list apne aap refresh)
      final selectedPropertyId = ref.watch(selectedPropertyIdProvider);
      final service = ref.read(authServiceProvider);
      return await service.getNotificaionList(
        filter: filter,
        propertyId: selectedPropertyId,
      );
   });
