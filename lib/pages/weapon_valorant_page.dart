import 'package:flutter/material.dart';

import '../models/valorant_post.dart';
import '../services/favorite_service.dart';
import '../services/valorant_services.dart';
import 'developer_profile_page.dart';
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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'SEMUA';

  // Daftar Kategori Filter
  static const List<String> _categories = [
    'SEMUA',
    '⭐ FAVORIT',
    'SIDEARMS',
    'SMGS',
    'SHOTGUNS',
    'RIFLES',
    'SNIPERS',
    'HEAVIES',
    'MELEE',
  ];

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  /// Mapping chip filter label → akhiran unik di weapon.category API
  /// Format API: "EEquippableCategory::Sidearm", "EEquippableCategory::SMG", dst.
  /// Pakai "::" + bentuk SINGULAR supaya cocok baik singular maupun plural.
  static const Map<String, String> _categoryKeywords = {
    'SIDEARMS': '::SIDEARM',   // cocok ke ::Sidearm
    'SMGS':     '::SMG',       // cocok ke ::SMG
    'SHOTGUNS': '::SHOTGUN',   // cocok ke ::Shotgun
    'RIFLES':   '::RIFLE',    // cocok ke ::Rifle, TIDAK cocok ke ::Sniper
    'SNIPERS':  '::SNIPER',   // cocok ke ::Sniper
    'HEAVIES':  '::HEAVY',    // cocok ke ::Heavy (Ares, Odin)
    'MELEE':    '::MELEE',    // cocok ke ::Melee
  };

  List<Datum> _filterWeapons(List<Datum> all, Set<String> favs) {
    return all.where((weapon) {
      // 1. Filter Pencarian
      final matchSearch = _searchQuery.isEmpty ||
          weapon.displayName.toLowerCase().contains(_searchQuery.toLowerCase());

      // 2. Filter Kategori — cocokkan ke weapon.category mentah dari API
      bool matchCategory = true;
      if (_selectedCategory == '⭐ FAVORIT') {
        matchCategory = favs.contains(weapon.uuid);
      } else if (_selectedCategory != 'SEMUA') {
        final rawCat = weapon.category.toUpperCase();
        final keyword = _categoryKeywords[_selectedCategory];
        if (keyword != null) {
          matchCategory = rawCat.contains(keyword);
        }
      }

      return matchSearch && matchCategory;
    }).toList();
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
        actions: [
          // Tombol Profil Pengembang / UAS
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white70),
            tooltip: 'Profil Pengembang',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DeveloperProfilePage(),
                ),
              );
            },
          ),
          // Tombol Muat Ulang API
          IconButton(
            icon: const Icon(Icons.refresh, color: _accentRed),
            tooltip: 'Muat Ulang',
            onPressed: _reload,
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white12,
            height: 1,
          ),
        ),
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: FavoriteService.instance.favoriteUuidsNotifier,
        builder: (context, favoriteUuids, _) {
          return FutureBuilder<Valorant>(
            future: _futureValorant,
            builder: (context, snapshot) {
              // 1. Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: _accentRed,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'MEMUAT DATA SENJATA...',
                        style: TextStyle(
                          color: _textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // 2. Error
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

              // 3. Data Berhasil
              final valorant = snapshot.data;
              final allWeapons = valorant?.data ?? [];
              final filteredWeapons = _filterWeapons(allWeapons, favoriteUuids);

              return Column(
                children: [
                  // Kolom Pencarian (Search Bar)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: _cardDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _searchQuery.isNotEmpty
                              ? _accentRed.withOpacity(0.8)
                              : Colors.white12,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari senjata (misal: Vandal, Operator)...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: _accentRed,
                            size: 20,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.white54,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Filter Kategori (Horizontal Chips)
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = _selectedCategory == cat;

                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = cat;
                              });
                            }
                          },
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : _textSecondary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.8,
                          ),
                          backgroundColor: _cardDark,
                          selectedColor: _accentRed,
                          side: BorderSide(
                            color: isSelected
                                ? _accentRed
                                : Colors.white.withOpacity(0.12),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          showCheckmark: false,
                        );
                      },
                    ),
                  ),

                  // Indikator Jumlah Hasil
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MENAMPILKAN ${filteredWeapons.length} SENJATA',
                          style: const TextStyle(
                            color: _textSecondary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        if (_selectedCategory == '⭐ FAVORIT')
                          Text(
                            '${favoriteUuids.length} TERSIMPAN',
                            style: const TextStyle(
                              color: _accentRed,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Daftar Senjata / Empty State
                  Expanded(
                    child: filteredWeapons.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _selectedCategory == '⭐ FAVORIT'
                                        ? Icons.favorite_border
                                        : Icons.search_off,
                                    size: 56,
                                    color: _accentRed.withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _selectedCategory == '⭐ FAVORIT'
                                        ? 'Belum ada senjata favorit tersimpan.\nKlik ikon hati pada senjata untuk menambahkan!'
                                        : 'Senjata "$_searchQuery" tidak ditemukan.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(14, 6, 14, 16),
                            itemCount: filteredWeapons.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final weapon = filteredWeapons[i];
                              final isFav = favoriteUuids.contains(weapon.uuid);
                              final categoryLabel =
                                  _formatCategory(weapon).toUpperCase();
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
                                  border: Border.all(
                                    color: isFav
                                        ? _accentRed.withOpacity(0.4)
                                        : Colors.white12,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WeaponDetail(weapon: weapon),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        // Garis aksen kiri
                                        Container(
                                          width: 3.5,
                                          height: 82,
                                          color: isFav
                                              ? _accentRed
                                              : _accentRed.withOpacity(0.6),
                                        ),
                                        const SizedBox(width: 10),

                                        // Thumbnail Foto Senjata (Klik untuk Zoom & Rotate)
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
                                            height: 56,
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: _bgDark.withOpacity(0.75),
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              border: Border.all(
                                                color: Colors.white10,
                                              ),
                                            ),
                                            child: Image.network(
                                              weapon.displayIcon,
                                              cacheWidth: 200,
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(
                                                Icons.image_not_supported,
                                                size: 24,
                                                color: Colors.white38,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Informasi Senjata
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  weapon.displayName
                                                      .toUpperCase(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 15,
                                                    letterSpacing: 0.6,
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
                                                      isRed:
                                                          weapon.shopData != null,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Tombol Favorit (Heart)
                                        IconButton(
                                          icon: Icon(
                                            isFav
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFav
                                                ? _accentRed
                                                : Colors.white38,
                                            size: 22,
                                          ),
                                          tooltip: isFav
                                              ? 'Hapus dari Favorit'
                                              : 'Simpan ke Favorit',
                                          onPressed: () {
                                            FavoriteService.instance
                                                .toggleFavorite(weapon.uuid);
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration: const Duration(
                                                  milliseconds: 1500,
                                                ),
                                                backgroundColor: _cardDark,
                                                content: Text(
                                                  isFav
                                                      ? '${weapon.displayName} dihapus dari Favorit'
                                                      : '${weapon.displayName} ditambahkan ke Favorit ❤️',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
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
