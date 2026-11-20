import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class FavoriteService {
  static final FavoriteService instance = FavoriteService._internal();

  FavoriteService._internal() {
    _loadFavorites();
  }

  final ValueNotifier<Set<String>> favoriteUuidsNotifier =
      ValueNotifier<Set<String>>({});

  File? _getStorageFile() {
    try {
      final tempDir = Directory.systemTemp.path;
      return File('$tempDir/valorant_favorites.json');
    } catch (_) {
      return null;
    }
  }

  void _loadFavorites() {
    try {
      final file = _getStorageFile();
      if (file != null && file.existsSync()) {
        final content = file.readAsStringSync();
        final List<dynamic> list = jsonDecode(content);
        favoriteUuidsNotifier.value = Set<String>.from(list);
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  void _saveFavorites() {
    try {
      final file = _getStorageFile();
      if (file != null) {
        final jsonStr = jsonEncode(favoriteUuidsNotifier.value.toList());
        file.writeAsStringSync(jsonStr);
      }
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  bool isFavorite(String uuid) {
    return favoriteUuidsNotifier.value.contains(uuid);
  }

  void toggleFavorite(String uuid) {
    final updated = Set<String>.from(favoriteUuidsNotifier.value);
    if (updated.contains(uuid)) {
      updated.remove(uuid);
    } else {
      updated.add(uuid);
    }
    favoriteUuidsNotifier.value = updated;
    _saveFavorites();
  }
}
