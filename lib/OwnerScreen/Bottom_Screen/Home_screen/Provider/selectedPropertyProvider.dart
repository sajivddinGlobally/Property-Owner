import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

dynamic getStoredSelectedPropertyId() {
  try {
    if (Hive.isBoxOpen("userdata")) {
      final id = Hive.box("userdata").get("selected_property_id");
      log("Loaded stored selected_property_id: $id");
      return id;
    }
  } catch (e) {
    log("Error getting stored selected_property_id: $e");
  }
  return null;
}

void persistSelectedPropertyId(dynamic id) {
  try {
    if (Hive.isBoxOpen("userdata")) {
      if (id != null) {
        Hive.box("userdata").put("selected_property_id", id);
        log("Persisted selected_property_id: $id");
      } else {
        Hive.box("userdata").delete("selected_property_id");
        log("Deleted selected_property_id from Hive");
      }
    }
  } catch (e) {
    log("Error persisting selected_property_id: $e");
  }
}

final selectedPropertyIdProvider = StateProvider<dynamic>((ref) {
  return getStoredSelectedPropertyId();
});
