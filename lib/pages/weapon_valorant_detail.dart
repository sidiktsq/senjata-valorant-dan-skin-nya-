import 'package:flutter/material.dart';

import '../models/valorant_post.dart';
import '../services/favorite_service.dart';
import 'image_viewer_page.dart';

class WeaponDetail extends StatelessWidget {
  final Datum weapon;

  const WeaponDetail({
    super.key,
    required this.weapon,
  });

  // Palet khas Valorant
  static const Color _bgDark = Color(0xFF0F1923);
  static const Color _surfaceDark = Color(0xFF17222D);
  static const Color _cardDark = Color(0xFF1F2731);
  static const Color _accentRed = Color(0xFFFF4655);
  static const Color _textSecondary = Color(0xFF8B978F);

  @override
  Widget build(BuildContext context) {
    final categoryText =
        weapon.shopData?.categoryText ?? weapon.category.split('::').last;
    final stats = weapon.weaponStats;

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
            Expanded(
              child: Text(
                weapon.displayName.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Tombol Favorit di Detail
          ValueListenableBuilder<Set<String>>(
            valueListenable: FavoriteService.instance.favoriteUuidsNotifier,
            builder: (context, favs, _) {
              final isFav = favs.contains(weapon.uuid);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? _accentRed : Colors.white70,
                ),
                tooltip: isFav ? 'Hapus dari Favorit' : 'Simpan ke Favorit',
                onPressed: () {
                  FavoriteService.instance.toggleFavorite(weapon.uuid);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 1500),
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
              );
            },
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white.withOpacity(0.08),
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Showcase Senjata (Dapat diklik untuk Zoom & Rotasi)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _cardDark,
                    _surfaceDark,
                    _accentRed.withOpacity(0.10),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.10)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImageViewerPage(
                          imageUrl: weapon.displayIcon,
                          title: weapon.displayName,
                          subtitle: 'Foto Utama Senjata',
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 28,
                          height: 3,
                          color: _accentRed,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 28,
                          horizontal: 18,
                        ),
                        child: Center(
                          child: Hero(
                            tag: 'weapon_img_${weapon.uuid}',
                            child: Image.network(
                              weapon.displayIcon,
                              cacheWidth: 600,
                              height: 126,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.broken_image,
                                size: 72,
                                color: Colors.white38,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Badge Petunjuk Klik untuk Zoom & Rotasi
                      Positioned(
                        bottom: 8,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _bgDark.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _accentRed.withOpacity(0.55),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.zoom_in,
                                color: _accentRed,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'KETUK UNTUK ZOOM & ROTASI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header Nama, Kategori & Harga
            Text(
              weapon.displayName.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ValorantTag(label: 'KATEGORI', value: categoryText.toUpperCase()),
                if (weapon.shopData != null)
                  _ValorantTag(
                    label: 'HARGA',
                    value: '${weapon.shopData!.cost} CREDITS',
                    isRed: true,
                  ),
                if (stats != null)
                  _ValorantTag(
                    label: 'PENETRASI',
                    value: stats.wallPenetration.name
                        .replaceAll('WALL_PENETRATION_', '')
                        .replaceAll('_', ' '),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            // Bagian Statistik Senjata (Jika bukan Melee)
            if (stats != null) ...[
              const _ValorantSectionHeader(title: 'STATISTIK SENJATA'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: _cardDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  children: [
                    _StatTile(
                      label: 'Fire Rate',
                      value: '${stats.fireRate} peluru / detik',
                    ),
                    _StatTile(
                      label: 'Kapasitas Magazin',
                      value: '${stats.magazineSize} peluru',
                    ),
                    _StatTile(
                      label: 'Waktu Reload',
                      value: '${stats.reloadTimeSeconds} detik',
                    ),
                    _StatTile(
                      label: 'Waktu Equip',
                      value: '${stats.equipTimeSeconds} detik',
                    ),
                    _StatTile(
                      label: 'Akurasi Peluru Pertama',
                      value: '${stats.firstBulletAccuracy}',
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Bagian Damage Berdasarkan Jarak
              if (stats.damageRanges.isNotEmpty) ...[
                const _ValorantSectionHeader(title: 'TABEL DAMAGE JARAK'),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stats.damageRanges.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final range = stats.damageRanges[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _cardDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.straighten,
                                size: 16,
                                color: _accentRed,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${range.rangeStartMeters}m - ${range.rangeEndMeters}m',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _DamageBox(
                                  zone: 'KEPALA',
                                  damage: range.headDamage.toStringAsFixed(1),
                                  accentColor: _accentRed,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _DamageBox(
                                  zone: 'BADAN',
                                  damage: range.bodyDamage.toStringAsFixed(1),
                                  accentColor: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _DamageBox(
                                  zone: 'KAKI',
                                  damage: range.legDamage.toStringAsFixed(1),
                                  accentColor: _textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 22),
              ],
            ],

            // Bagian Daftar Skins
            _ValorantSectionHeader(title: 'SKINS (${weapon.skins.length})'),
            const SizedBox(height: 6),
            const Text(
              'Ketuk skin untuk melihat varian warna (Chroma) & Zoom/Rotasi',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: weapon.skins.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final skin = weapon.skins[index];
                final skinImageUrl = skin.displayIcon ??
                    (skin.chromas.isNotEmpty
                        ? (skin.chromas.first.displayIcon ??
                            skin.chromas.first.fullRender)
                        : null);

                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: _cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showSkinChromaSheet(context, skin, weapon),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            // Garis aksen tipis di sisi kiri kartu
                            Container(
                              width: 3,
                              color: _accentRed.withOpacity(0.75),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 82,
                              height: 52,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _bgDark.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: skinImageUrl != null
                                  ? Image.network(
                                      skinImageUrl,
                                      cacheWidth: 200,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.image_not_supported,
                                        size: 22,
                                        color: Colors.white38,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.image_not_supported,
                                      size: 22,
                                      color: Colors.white38,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      skin.displayName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${skin.chromas.length} CHROMA  •  ${skin.levels.length} LEVEL',
                                      style: const TextStyle(
                                        color: _textSecondary,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _bgDark.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Colors.white10,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.palette,
                                  color: _accentRed,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  void _showSkinChromaSheet(BuildContext context, Skin skin, Datum weapon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SkinChromaSheet(skin: skin, weapon: weapon),
    );
  }
}

class _SkinChromaSheet extends StatefulWidget {
  final Skin skin;
  final Datum weapon;

  const _SkinChromaSheet({
    required this.skin,
    required this.weapon,
  });

  @override
  State<_SkinChromaSheet> createState() => _SkinChromaSheetState();
}

class _SkinChromaSheetState extends State<_SkinChromaSheet> {
  int _selectedChromaIndex = 0;

  @override
  Widget build(BuildContext context) {
    final chromas = widget.skin.chromas;
    final currentChroma =
        chromas.isNotEmpty ? chromas[_selectedChromaIndex] : null;

    final String? currentImageUrl = currentChroma != null
        ? (currentChroma.fullRender.isNotEmpty
            ? currentChroma.fullRender
            : (currentChroma.displayIcon ?? widget.skin.displayIcon))
        : widget.skin.displayIcon;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: WeaponDetail._surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: WeaponDetail._accentRed, width: 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.skin.displayName.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'VARIAN WARNA (CHROMA) • ${widget.weapon.displayName.toUpperCase()}',
                        style: const TextStyle(
                          color: WeaponDetail._accentRed,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),

          // Scrollable Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview Box (Dapat diklik untuk Zoom & Rotasi)
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: WeaponDetail._bgDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: currentImageUrl != null &&
                                currentImageUrl.isNotEmpty
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ImageViewerPage(
                                      imageUrl: currentImageUrl,
                                      title: currentChroma?.displayName ??
                                          widget.skin.displayName,
                                      subtitle:
                                          'Skin ${widget.weapon.displayName}',
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: Stack(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: currentImageUrl != null &&
                                        currentImageUrl.isNotEmpty
                                    ? Image.network(
                                        currentImageUrl,
                                        cacheWidth: 600,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                          Icons.broken_image,
                                          size: 60,
                                          color: Colors.white38,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.image_not_supported,
                                        size: 60,
                                        color: Colors.white38,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: WeaponDetail._bgDark.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: WeaponDetail._accentRed
                                        .withOpacity(0.6),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.zoom_in,
                                      color: WeaponDetail._accentRed,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'KETUK UNTUK ZOOM & ROTASI',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Nama Varian Terpilih
                  if (currentChroma != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: WeaponDetail._cardDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.palette,
                            color: WeaponDetail._accentRed,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              currentChroma.displayName.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Selector Varian Chroma
                  if (chromas.length > 1) ...[
                    Text(
                      'PILIH VARIAN WARNA (${chromas.length} VARIAN)',
                      style: const TextStyle(
                        color: WeaponDetail._textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: chromas.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, idx) {
                          final chroma = chromas[idx];
                          final isSelected = idx == _selectedChromaIndex;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedChromaIndex = idx;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 60,
                              decoration: BoxDecoration(
                                color: WeaponDetail._cardDark,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? WeaponDetail._accentRed
                                      : Colors.white12,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: chroma.swatch != null &&
                                        chroma.swatch!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        child: Image.network(
                                          chroma.swatch!,
                                          cacheWidth: 100,
                                          width: 38,
                                          height: 38,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Text(
                                            'V${idx + 1}',
                                            style: TextStyle(
                                              color: isSelected
                                                  ? WeaponDetail._accentRed
                                                  : Colors.white70,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'V${idx + 1}',
                                        style: TextStyle(
                                          color: isSelected
                                              ? WeaponDetail._accentRed
                                              : Colors.white70,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Tombol Buka Fullscreen Zoom & Rotasi
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WeaponDetail._accentRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.fullscreen, size: 20),
                      label: const Text(
                        'BUKA FOTO PENUH (ZOOM & ROTASI)',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12.5,
                          letterSpacing: 0.8,
                        ),
                      ),
                      onPressed: currentImageUrl != null &&
                              currentImageUrl.isNotEmpty
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ImageViewerPage(
                                    imageUrl: currentImageUrl,
                                    title: currentChroma?.displayName ??
                                        widget.skin.displayName,
                                    subtitle:
                                        'Skin ${widget.weapon.displayName}',
                                  ),
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValorantSectionHeader extends StatelessWidget {
  final String title;

  const _ValorantSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: WeaponDetail._accentRed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.3,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.08),
          ),
        ),
      ],
    );
  }
}

class _ValorantTag extends StatelessWidget {
  final String label;
  final String value;
  final bool isRed;

  const _ValorantTag({
    required this.label,
    required this.value,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isRed
            ? WeaponDetail._accentRed.withOpacity(0.14)
            : WeaponDetail._cardDark,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isRed
              ? WeaponDetail._accentRed.withOpacity(0.55)
              : Colors.white.withOpacity(0.10),
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                color: isRed
                    ? WeaponDetail._accentRed.withOpacity(0.8)
                    : WeaponDetail._textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: isRed ? WeaponDetail._accentRed : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _StatTile({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: WeaponDetail._textSecondary,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _DamageBox extends StatelessWidget {
  final String zone;
  final String damage;
  final Color accentColor;

  const _DamageBox({
    required this.zone,
    required this.damage,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: WeaponDetail._bgDark.withOpacity(0.75),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accentColor == WeaponDetail._accentRed
              ? WeaponDetail._accentRed.withOpacity(0.45)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: Column(
        children: [
          Text(
            zone,
            style: TextStyle(
              color: accentColor.withOpacity(0.85),
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            damage,
            style: TextStyle(
              color: accentColor,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
