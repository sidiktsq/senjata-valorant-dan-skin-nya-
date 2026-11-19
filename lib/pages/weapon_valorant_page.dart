import 'package:flutter/material.dart';

import '../models/valorant_post.dart';
import '../services/valorant_services.dart';
import 'image_viewer_page.dart';
import 'weapon_valorant_detail.dart';

class ValorantPage extends StatefulWidget {
  const ValorantPage({super.key});

  @override
  State<ValorantPage> createState() => _ValorantPageState();
}

class _ValorantPageState extends State<ValorantPage> {
  final ValorantServices _api = ValorantServices();
  late Future<Valorant> _futureValorant;

  // Palet khas Valorant
  static const Color _bgDark = Color(0xFF0F1923);
  static const Color _surfaceDark = Color(0xFF17222D);
  static const Color _cardDark = Color(0xFF1F2731);
  static const Color _accentRed = Color(0xFFFF4655);
  static const Color _textSecondary = Color(0xFF8B978F);

  @override
  void initState() {
    super.initState();
    _futureValorant = _api.fetchValorant();
  }

  void _reload() {
    setState(() {
      _futureValorant = _api.fetchValorant();
    });
  }

  String _formatCategory(Datum weapon) {
    final categoryText = weapon.shopData?.categoryText;
    if (categoryText != null && categoryText.isNotEmpty) {
      return categoryText;
    }
    return weapon.category.split('::').last;
  }

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
              'ARSENAL VALORANT',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
                fontSize: 17,
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: _cardDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: _accentRed, size: 20),
              onPressed: _reload,
              tooltip: 'Muat Ulang',
            ),
          ),
        ],
      ),
      body: FutureBuilder<Valorant>(
        future: _futureValorant,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: _accentRed),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _accentRed.withOpacity(0.45),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off,
                        size: 44,
                        color: _accentRed,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Terjadi kesalahan:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _reload,
                        child: const Text(
                          'COBA LAGI',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Data berhasil
          final valorant = snapshot.data;
          final weapons = valorant?.data ?? [];

          if (weapons.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data senjata',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            itemCount: weapons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final weapon = weapons[i];
              final categoryLabel = _formatCategory(weapon).toUpperCase();
              final costText = weapon.shopData != null
                  ? '${weapon.shopData!.cost} CREDITS'
                  : 'FREE / MELEE';

              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      _cardDark,
                      _surfaceDark,
                      _accentRed.withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeaponDetail(weapon: weapon),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        // Garis aksen tipis di sisi kiri kartu
                        Container(
                          width: 3,
                          height: 78,
                          color: _accentRed.withOpacity(0.8),
                        ),
                        const SizedBox(width: 12),

                        // Bingkai ikon senjata (Dapat diklik langsung untuk Zoom & Rotasi)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ImageViewerPage(
                                  imageUrl: weapon.displayIcon,
                                  title: weapon.displayName,
                                  subtitle: 'Senjata Valorant',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 86,
                            height: 54,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: _bgDark.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Image.network(
                              weapon.displayIcon,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 24,
                                  color: Colors.white38,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Informasi senjata
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weapon.displayName.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    _MiniBadge(
                                      text: categoryLabel,
                                      isRed: false,
                                    ),
                                    _MiniBadge(
                                      text: costText,
                                      isRed: weapon.shopData != null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.white38,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String text;
  final bool isRed;

  const _MiniBadge({
    required this.text,
    required this.isRed,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isRed
        ? const Color(0xFFFF4655).withOpacity(0.15)
        : const Color(0xFF0F1923).withOpacity(0.75);

    final Color borderColor = isRed
        ? const Color(0xFFFF4655).withOpacity(0.45)
        : Colors.white12;

    final Color textColor =
        isRed ? const Color(0xFFFF4655) : const Color(0xFF8B978F);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}