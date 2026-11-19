import 'package:flutter/material.dart';

import '../models/valorant_post.dart';
import '../services/valorant_services.dart';
import 'weapon_valorant_detail.dart';

class ValorantPage extends StatefulWidget {
  const ValorantPage({super.key});

  @override
  State<ValorantPage> createState() => _ValorantPageState();
}

class _ValorantPageState extends State<ValorantPage> {
  final ValorantServices _api = ValorantServices();

  late Future<Valorant> _futureValorant;

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
      appBar: AppBar(
        title: const Text('Daftar Senjata Valorant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<Valorant>(
        future: _futureValorant,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Terjadi kesalahan:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Data berhasil
          final valorant = snapshot.data;
          final weapons = valorant?.data ?? [];

          if (weapons.isEmpty) {
            return const Center(
              child: Text('Belum ada data senjata'),
            );
          }

          return ListView.builder(
            itemCount: weapons.length,
            itemBuilder: (context, i) {
              final weapon = weapons[i];
              final categoryLabel = _formatCategory(weapon);
              final costText = weapon.shopData != null
                  ? ' • ${weapon.shopData!.cost} Credits'
                  : '';

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeaponDetail(weapon: weapon),
                      ),
                    );
                  },
                  leading: Image.network(
                    weapon.displayIcon,
                    width: 55,
                    height: 55,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 40,
                      );
                    },
                  ),
                  title: Text(
                    weapon.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '$categoryLabel$costText',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
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
