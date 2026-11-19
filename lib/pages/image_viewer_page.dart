import 'dart:math' as math;
import 'package:flutter/material.dart';

class ImageViewerPage extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String? subtitle;

  const ImageViewerPage({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
  });

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  // Palet warna khas Valorant
  static const Color _bgDark = Color(0xFF0F1923);
  static const Color _cardDark = Color(0xFF17222D);
  static const Color _accentRed = Color(0xFFFF4655);
  static const Color _textSecondary = Color(0xFF8B978F);

  final TransformationController _transformationController =
      TransformationController();

  double _rotationAngle = 0.0; // Dalam derajat (0 - 360)
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformChanged);
  }

  void _onTransformChanged() {
    setState(() {
      _currentScale = _transformationController.value.getMaxScaleOnAxis();
    });
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    super.dispose();
  }

  // Fungsi rotasi searah jarum jam (+90 derajat)
  void _rotateClockwise() {
    setState(() {
      _rotationAngle = (_rotationAngle + 90) % 360;
    });
  }

  // Fungsi rotasi berlawanan jarum jam (-90 derajat)
  void _rotateCounterClockwise() {
    setState(() {
      _rotationAngle = (_rotationAngle - 90) % 360;
      if (_rotationAngle < 0) _rotationAngle += 360;
    });
  }

  // Fungsi zoom manual in / out
  void _zoom(double factor) {
    final currentMatrix = _transformationController.value;
    final newScale = (_currentScale * factor).clamp(0.5, 6.0);
    final ratio = newScale / _currentScale;

    final newMatrix = currentMatrix.clone()..scale(ratio, ratio);
    setState(() {
      _transformationController.value = newMatrix;
    });
  }

  // Fungsi reset ke posisi awal (zoom 1.0 dan rotasi 0)
  void _resetTransform() {
    setState(() {
      _rotationAngle = 0.0;
      _transformationController.value = Matrix4.identity();
    });
  }

  // Double tap untuk toggle zoom
  void _handleDoubleTap() {
    if (_currentScale > 1.2) {
      _resetTransform();
    } else {
      _zoom(2.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedAngle = _rotationAngle.toInt();
    final formattedScale = _currentScale.toStringAsFixed(1);

    return Scaffold(
      backgroundColor: _bgDark,
      appBar: AppBar(
        backgroundColor: _bgDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
            if (widget.subtitle != null)
              Text(
                widget.subtitle!.toUpperCase(),
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 11,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: _accentRed),
            tooltip: 'Reset Zoom & Rotasi',
            onPressed: _resetTransform,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white12,
            height: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Area Foto dengan Pinch-to-Zoom dan Rotasi
          GestureDetector(
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 6.0,
              boundaryMargin: const EdgeInsets.all(80),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Transform.rotate(
                    angle: _rotationAngle * (math.pi / 180),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: _accentRed,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.broken_image,
                                color: _accentRed,
                                size: 64,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Gagal memuat gambar',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Status Bar Indikator (Zoom & Sudut Rotasi) di bagian atas
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _cardDark.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.zoom_in, color: _accentRed, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '${formattedScale}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(width: 1, height: 12, color: Colors.white24),
                    const SizedBox(width: 14),
                    const Icon(Icons.rotate_90_degrees_cw, color: _accentRed, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '$formattedAngle°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Kontrol Panel Rotasi & Zoom di Bagian Bawah
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: _cardDark.withOpacity(0.92),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Slider Rotasi Halus (0 - 360 Derajat)
                  Row(
                    children: [
                      const Icon(Icons.rotate_left, color: _textSecondary, size: 18),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: _accentRed,
                            inactiveTrackColor: Colors.white12,
                            thumbColor: _accentRed,
                            overlayColor: _accentRed.withOpacity(0.2),
                            trackHeight: 3,
                          ),
                          child: Slider(
                            value: _rotationAngle,
                            min: 0,
                            max: 360,
                            divisions: 72, // Setiap 5 derajat
                            onChanged: (val) {
                              setState(() {
                                _rotationAngle = val;
                              });
                            },
                          ),
                        ),
                      ),
                      const Icon(Icons.rotate_right, color: _textSecondary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Tombol Cepat Rotasi & Zoom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Putar Kiri 90°
                      _ControlButton(
                        icon: Icons.rotate_left,
                        label: '-90°',
                        onTap: _rotateCounterClockwise,
                      ),
                      // Putar Kanan 90°
                      _ControlButton(
                        icon: Icons.rotate_right,
                        label: '+90°',
                        onTap: _rotateClockwise,
                      ),
                      // Zoom In
                      _ControlButton(
                        icon: Icons.zoom_in,
                        label: 'Zoom +',
                        onTap: () => _zoom(1.3),
                      ),
                      // Zoom Out
                      _ControlButton(
                        icon: Icons.zoom_out,
                        label: 'Zoom -',
                        onTap: () => _zoom(0.7),
                      ),
                      // Reset
                      _ControlButton(
                        icon: Icons.refresh,
                        label: 'Reset',
                        isAccent: true,
                        onTap: _resetTransform,
                      ),
                    ],
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

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isAccent;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    const accentRed = Color(0xFFFF4655);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isAccent
              ? accentRed.withOpacity(0.18)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isAccent ? accentRed.withOpacity(0.5) : Colors.white10,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isAccent ? accentRed : Colors.white,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isAccent ? accentRed : Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
