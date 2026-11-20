import 'package:flutter/material.dart';

class DeveloperProfilePage extends StatelessWidget {
  const DeveloperProfilePage({super.key});

  // Palet warna khas Valorant
  static const Color _bgDark = Color(0xFF0F1923);
  static const Color _surfaceDark = Color(0xFF17222D);
  static const Color _cardDark = Color(0xFF1F2731);
  static const Color _accentRed = Color(0xFFFF4655);
  static const Color _textSecondary = Color(0xFF8B978F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      appBar: AppBar(
        backgroundColor: _bgDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              margin: const EdgeInsets.only(right: 10),
              color: _accentRed,
            ),
            const Text(
              'PROFIL PENGEMBANG',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.3,
                fontSize: 16,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white12,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Card Profil Utama Pengembang
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _cardDark,
                    _surfaceDark,
                    _accentRed.withOpacity(0.12),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _accentRed.withOpacity(0.35)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar dengan bingkai glowing merah
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _accentRed, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: _accentRed.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 46,
                      backgroundColor: _surfaceDark,
                      child: Icon(
                        Icons.person,
                        size: 52,
                        color: _accentRed,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nama Mahasiswa / Siswa
                  const Text(
                    'Rizky Mochamad Sidik',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Badge Role
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _accentRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _accentRed.withOpacity(0.6)),
                    ),
                    child: const Text(
                      'DEVELOPER & SISWA',
                      style: TextStyle(
                        color: _accentRed,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card Rincian Identitas Akademik (UAS)
            _SectionCard(
              title: 'DATA AKADEMIK / UAS',
              icon: Icons.school,
              items: const [
                _InfoItem(label: 'NAMA LENGKAP', value: 'Rizky Mochamad Sidik'),
                _InfoItem(label: 'JURUSAN', value: 'Teknik Informatika / RPL'),
                _InfoItem(label: 'TUGAS', value: 'Ujian Akhir Semester (UAS)'),
              ],
            ),
            const SizedBox(height: 18),

            // Card Tentang Aplikasi
            _SectionCard(
              title: 'TENTANG APLIKASI',
              icon: Icons.info_outline,
              items: const [
                _InfoItem(label: 'NAMA APLIKASI', value: 'Skin Valorant'),
                _InfoItem(label: 'VERSI', value: 'v1.0.0 (Release)'),
                _InfoItem(label: 'FRAMEWORK', value: 'Flutter & Dart'),
                _InfoItem(label: 'SUMBER API', value: 'valorant-api.com (REST API)'),
                _InfoItem(
                  label: 'FITUR UTAMA',
                  value: 'Search, Filter Kategori, Zoom & Rotasi 360°, Simpan Favorit, Showcase Varian Chroma Skin',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Footer
            Center(
              child: Text(
                '© 2026 UAS SKIN VALORANT • ALL RIGHTS RESERVED',
                style: TextStyle(
                  color: _textSecondary.withOpacity(0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_InfoItem> items;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    const accentRed = Color(0xFFFF4655);
    const cardDark = Color(0xFF1F2731);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 18, color: accentRed),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.white10),

          // Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(
                          item.label,
                          style: const TextStyle(
                            color: Color(0xFF8B978F),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});
}
