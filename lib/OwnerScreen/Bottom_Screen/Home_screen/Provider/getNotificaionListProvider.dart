import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getNotificaionListModel.dart';

final getNotificaionListProvider = FutureProvider.family
    .autoDispose<GetNotificaionListModel, String>((ref, filter) async {
      final service = ref.read(authServiceProvider);
      return await service.getNotificaionList(filter: filter);
    });
