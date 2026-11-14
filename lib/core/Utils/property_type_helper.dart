// String formatPropertyTitle(String? text) {
//   if (text == null || text.trim().isEmpty) return "";
//   final trimmed = text.trim();
//   final lower = trimmed.toLowerCase();
//   if (lower == "independent_house") return "Independent House";
//   if (lower == "apartment") return "Apartment";
//   if (lower == "villa_compound") return "Villa Compound";
//   if (lower == "commercial") return "Commercial";
//   if (lower == "commercial_complex") return "Commercial Complex";

//   if (trimmed.contains('_') && !trimmed.contains(' ')) {
//     return trimmed
//         .split('_')
//         .map(
//           (w) => w.isNotEmpty
//               ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
//               : '',
//         )
//         .join(' ');
//   }
//   return trimmed;
// }

// String formatPropertyType(String? type) {
//   if (type == null || type.trim().isEmpty) return "N/A";
//   final lower = type.trim().toLowerCase();
//   if (lower == "independent_house") {
//     return "Independent House";
//   }
//   if (lower == "home_care") {
//     return "Home Care";
//   }
//   if (lower == "apartment") {
//     return "Apartment";
//   }
//   if (lower == "community_care") {
//     return "Community Care";
//   }
//   if (lower == "villa_compound") {
//     return "Villa Compound";
//   }
//   if (lower == "commercial") {
//     return "Commercial";
//   }
//   if (lower == "commercial_complex") {
//     return "Commercial Complex";
//   }
//   return type
//       .replaceAll('_', ' ')
//       .split(' ')
//       .map(
//         (w) => w.isNotEmpty
//             ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
//             : '',
//       )
//       .join(' ');
// }

String formatPropertyTitle(String? text) {
  if (text == null || text.trim().isEmpty) return "";
  final trimmed = text.trim();
  final lower = trimmed.toLowerCase();
  if (lower == "independent_house") return "Independent House";
  if (lower == "apartment") return "Apartment";
  if (lower == "villa_compound") return "Villa Compound";
  if (lower == "commercial") return "Commercial";
  if (lower == "commercial_complex") return "Commercial Complex";

  if (trimmed.contains('_') && !trimmed.contains(' ')) {
    return trimmed
        .split('_')
        .map(
          (w) => w.isNotEmpty
              ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }
  return trimmed;
}

String formatPropertyType(String? type) {
  if (type == null || type.trim().isEmpty) return "N/A";
  final lower = type.trim().toLowerCase();
  if (lower == "independent_house") {
    return "Independent House";
  }
  if (lower == "home_care") {
    return "Home Care";
  }
  if (lower == "apartment") {
    return "Apartment";
  }
  if (lower == "community_care") {
    return "Community Care";
  }
  if (lower == "villa_compound") {
    return "Villa Compound";
  }
  if (lower == "commercial") {
    return "Commercial";
  }
  if (lower == "commercial_complex") {
    return "Commercial Complex";
  }
  return type
      .replaceAll('_', ' ')
      .split(' ')
      .map(
        (w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
            : '',
      )
      .join(' ');
}

/// Home Care property? (backend jaisa) = Independent House, ya Commercial (shop / office)
/// jo kisi complex mein nahi. [complex] = API ka complex object / id (null = complex nahi).
bool isHomeCareProperty(String? type, {dynamic complex}) {
  final lower = (type ?? '').trim().toLowerCase();
  if (lower == "independent_house") return true;
  if (lower == "commercial") return complex == null;
  return false;
}
