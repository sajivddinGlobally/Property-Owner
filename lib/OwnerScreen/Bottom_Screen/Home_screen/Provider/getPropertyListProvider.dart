import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/propertyListModel.dart';

final getPropertyListProvider = FutureProvider.autoDispose<PropertyListModel>((
  ref,
) async {
  final selectedPropertyId = ref.watch(selectedPropertyIdProvider);
  final service = ref.read(authServiceProvider);

  try {
    final propertyList = await service.getPropertyList(
      selectedId: selectedPropertyId,
    );

    final properties = propertyList.data ?? [];
    if (properties.isNotEmpty) {
      final hasSelected =
          selectedPropertyId != null &&
          properties.any((p) => p.id == selectedPropertyId);
      if (!hasSelected) {
        // If current selectedId does not exist in this user's list (e.g. after switching accounts),
        // pick the backend isSelected property or the first property:
        final backendSelected = properties.firstWhere(
          (p) => p.isSelected == true,
          orElse: () => properties.first,
        );
        if (backendSelected.id != null) {
          log(
            "getPropertyListProvider syncing selectedPropertyId to ${backendSelected.id}",
          );
          Future.microtask(() {
            ref.read(selectedPropertyIdProvider.notifier).state =
                backendSelected.id;
            persistSelectedPropertyId(backendSelected.id);
          });
        }
      }
    }

    return propertyList;
  } catch (e) {
    if (selectedPropertyId != null) {
      log(
        "getPropertyListProvider failed with selectedId $selectedPropertyId, retrying with null: $e",
      );
      final propertyList = await service.getPropertyList(selectedId: null);
      final properties = propertyList.data ?? [];
      if (properties.isNotEmpty) {
        final backendSelected = properties.firstWhere(
          (p) => p.isSelected == true,
          orElse: () => properties.first,
        );
        if (backendSelected.id != null) {
          Future.microtask(() {
            ref.read(selectedPropertyIdProvider.notifier).state =
                backendSelected.id;
            persistSelectedPropertyId(backendSelected.id);
          });
        }
      }
      return propertyList;
    }
    rethrow;
  }
});
