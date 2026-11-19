import 'package:flutter/material.dart';

import '../models/valorant_post.dart';

class WeaponDetail extends StatelessWidget {
  final Datum weapon;

  const WeaponDetail({
    super.key,
    required this.weapon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weapon.displayName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Senjata
            Center(
              child: Image.network(
                weapon.displayIcon,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),
            const SizedBox(height: 16),

            // Nama & Kategori Senjata
            Text(
              weapon.displayName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Kategori: ${weapon.shopData?.categoryText ?? weapon.category.split('::').last}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (weapon.shopData != null) ...[
              const SizedBox(height: 4),
              Text(
                'Harga: ${weapon.shopData!.cost} Credits',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],

            const Divider(height: 32),

            // Bagian Weapon Stats (Dicek null karena Melee tidak punya stats)
            if (weapon.weaponStats != null) ...[
              Text(
                'Statistik Senjata',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text('Fire Rate: ${weapon.weaponStats!.fireRate} peluru/detik'),
              const SizedBox(height: 6),
              Text('Magazine Size: ${weapon.weaponStats!.magazineSize}'),
              const SizedBox(height: 6),
              Text('Reload Time: ${weapon.weaponStats!.reloadTimeSeconds} detik'),
              const SizedBox(height: 6),
              Text('Equip Time: ${weapon.weaponStats!.equipTimeSeconds} detik'),
              const SizedBox(height: 6),
              Text('First Bullet Accuracy: ${weapon.weaponStats!.firstBulletAccuracy}'),

              const SizedBox(height: 20),

              // Bagian Damage Ranges
              if (weapon.weaponStats!.damageRanges.isNotEmpty) ...[
                Text(
                  'Damage Berdasarkan Jarak',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...weapon.weaponStats!.damageRanges.map(
                  (range) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${range.rangeStartMeters}m - ${range.rangeEndMeters}m  |  '
                      'Head: ${range.headDamage} • Body: ${range.bodyDamage} • Leg: ${range.legDamage}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
              const Divider(height: 32),
            ],

            // Bagian Daftar Skins
            Text(
              'Daftar Skin (${weapon.skins.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: weapon.skins.length,
              itemBuilder: (context, index) {
                final skin = weapon.skins[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: skin.displayIcon != null
                      ? Image.network(
                          skin.displayIcon!,
                          width: 70,
                          fit: BoxFit.contain,
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(skin.displayName),
                  subtitle: Text('${skin.chromas.length} Chroma • ${skin.levels.length} Level'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
