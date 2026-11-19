import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tenant ki photo - SIRF wahi jo Owner Panel (Home Care Admin) ne daali (API image_url).
/// Photo nahi / link toota -> naam ka pehla akshar (koi dummy photo / icon nahi).
class TenantAvatar extends StatelessWidget {
  final String? name;
  final dynamic imageUrl;
  final double size;

  const TenantAvatar({super.key, this.name, this.imageUrl, required this.size});

  static String initial(String? name) {
    final n = (name ?? '').trim();
    if (n.isEmpty || n == '-') return 'T';
    return n.substring(0, 1).toUpperCase();
  }

  Widget _letter() {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0x33AE8130),
      ),
      child: Text(
        initial(name),
        style: GoogleFonts.outfit(
          fontSize: size * 0.42,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFAE8130),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = (imageUrl ?? '').toString().trim();
    final hasUrl = url.isNotEmpty && url.toLowerCase() != 'null';
    return ClipOval(
      child: hasUrl
          ? Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _letter(),
            )
          : _letter(),
    );
  }
}
