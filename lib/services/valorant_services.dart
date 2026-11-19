import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../constants/valorant_constants.dart';
import '../models/valorant_post.dart';

class ValorantServices {
  Future<Valorant> fetchValorant() async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.weaponsEndpoint}');

    try {
      // 1. Minta data dari API
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 10));

      // 2. Cek status response
      if (response.statusCode == 200) {
        // 3. Decode JSON dan ubah menjadi objek Valorant
        return Valorant.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Gagal memuat data (kode: ${response.statusCode})',
        );
      }
    } on TimeoutException {
      throw Exception('Koneksi terlalu lama. Coba lagi.');
    } on http.ClientException {
      throw Exception('Terjadi kesalahan koneksi.');
    }
  }
}
