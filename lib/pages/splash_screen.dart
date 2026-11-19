import 'dart:async';
import 'package:flutter/material.dart';
import 'weapon_valorant_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi animasi fade dan scale
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    // Navigasi ke halaman utama setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => const ValorantPage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const valorantDark = Color(0xFF0F1923); // Background gelap khas Valorant
    const valorantRed = Color(0xFFFF4655);  // Merah radiant khas Valorant
    const valorantText = Color(0xFFECE8E1); // Putih off-white khas Valorant

    return Scaffold(
      backgroundColor: valorantDark,
      body: Stack(
        children: [
          // Aksen garis dekoratif futuristik khas Valorant di background
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: valorantRed.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: valorantRed.withOpacity(0.06),
              ),
            ),
          ),

          // Konten Tengah
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo Aplikasi dengan efek Glow
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: valorantRed.withOpacity(0.45),
                            blurRadius: 36,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback icon jika asset belum dimuat
                            return Container(
                              width: 130,
                              height: 130,
                              color: const Color(0xFF1F2326),
                              child: const Icon(
                                Icons.shield,
                                color: valorantRed,
                                size: 70,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Judul Aplikasi
                    const Text(
                      'SKIN VALORANT',
                      style: TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4.5,
                        color: valorantText,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle / Tagline
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: valorantRed.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: valorantRed.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'WEAPONS & SKINS ARSENAL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.2,
                          color: valorantRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Loading & Footer di bagian bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(valorantRed),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'MEMUAT DATA SENJATA...',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w600,
                      color: valorantText.withOpacity(0.6),
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
