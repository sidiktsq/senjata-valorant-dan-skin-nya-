import 'package:flutter/material.dart';

import '../models/valorant_post.dart';

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
            // Hero Showcase Senjata
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
                      child: Image.network(
                        weapon.displayIcon,
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
                ],
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
                _ValorantTag(
                  label: 'TYPE',
                  value: categoryText.toUpperCase(),
                ),
                if (weapon.shopData != null)
                  _ValorantTag(
                    label: 'COST',
                    value: '${weapon.shopData!.cost} CREDITS',
                    isRed: true,
                  ),
              ],
            ),

            // Bagian Weapon Stats (Dicek null karena Melee tidak punya stats)
            if (stats != null) ...[
              const SizedBox(height: 26),
              const _ValorantSectionHeader(title: 'WEAPON STATS'),
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
                      value: '${stats.fireRate} /s',
                    ),
                    _StatTile(
                      label: 'Magazine Size',
                      value: '${stats.magazineSize}',
                    ),
                    _StatTile(
                      label: 'Reload Time',
                      value: '${stats.reloadTimeSeconds}s',
                    ),
                    _StatTile(
                      label: 'Equip Time',
                      value: '${stats.equipTimeSeconds}s',
                    ),
                    _StatTile(
                      label: 'First Bullet Accuracy',
                      value: '${stats.firstBulletAccuracy}',
                      isLast: true,
                    ),
                  ],
                ),
              ),

              // Bagian Damage Ranges
              if (stats.damageRanges.isNotEmpty) ...[
                const SizedBox(height: 24),
                const _ValorantSectionHeader(title: 'DAMAGE BY RANGE'),
                const SizedBox(height: 12),
                ...stats.damageRanges.map(
                  (range) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _cardDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${range.rangeStartMeters}M – ${range.rangeEndMeters}M',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                fontSize: 13.5,
                              ),
                            ),
                            Text(
                              'DISTANCE',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.35),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _DamageBox(
                                zone: 'HEAD',
                                damage: '${range.headDamage}',
                                accentColor: _accentRed,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _DamageBox(
                                zone: 'BODY',
                                damage: '${range.bodyDamage}',
                                accentColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _DamageBox(
                                zone: 'LEG',
                                damage: '${range.legDamage}',
                                accentColor: _textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 24),

            // Bagian Daftar Skins
            _ValorantSectionHeader(title: 'SKINS (${weapon.skins.length})'),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: weapon.skins.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final skin = weapon.skins[index];
                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: _cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
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
                          child: skin.displayIcon != null
                              ? Image.network(
                                  skin.displayIcon!,
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
                        const SizedBox(width: 12),
                      ],
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