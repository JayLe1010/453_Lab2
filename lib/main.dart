import 'package:flutter/material.dart';

void main() {
  runApp(const ArtSpaceApp());
}

class ArtSpaceApp extends StatelessWidget {
  const ArtSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3A3A3A),
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
        useMaterial3: true,
      ),
      home: const ArtSpaceHomePage(),
    );
  }
}

enum ArtStyle { waves, triangles, circles, stripes }

class Artwork {
  const Artwork({
    required this.title,
    required this.artist,
    required this.year,
    required this.style,
    required this.palette,
  });

  final String title;
  final String artist;
  final int year;
  final ArtStyle style;
  final List<Color> palette;
}

const List<Artwork> _artworks = [
  Artwork(
    title: 'Sunset Waves',
    artist: 'Alex Rivera',
    year: 2023,
    style: ArtStyle.waves,
    palette: [Color(0xFFFF7E5F), Color(0xFFFEB47B), Color(0xFFFFD59E)],
  ),
  Artwork(
    title: 'Geometric Bloom',
    artist: 'Mia Chen',
    year: 2021,
    style: ArtStyle.triangles,
    palette: [Color(0xFF4A90E2), Color(0xFF50C9C3), Color(0xFF2E3A59)],
  ),
  Artwork(
    title: 'Circles in Motion',
    artist: 'Jordan Lee',
    year: 2022,
    style: ArtStyle.circles,
    palette: [Color(0xFF9C27B0), Color(0xFFE91E63), Color(0xFFFFC107)],
  ),
  Artwork(
    title: 'Golden Fields',
    artist: 'Priya Nair',
    year: 2020,
    style: ArtStyle.stripes,
    palette: [Color(0xFFD4A017), Color(0xFF6B8E23), Color(0xFFFFF8DC)],
  ),
];

/// Home screen, divided into three sections: the artwork wall, the
/// artwork descriptor, and the display controller.
class ArtSpaceHomePage extends StatefulWidget {
  const ArtSpaceHomePage({super.key});

  @override
  State<ArtSpaceHomePage> createState() => _ArtSpaceHomePageState();
}

class _ArtSpaceHomePageState extends State<ArtSpaceHomePage> {
  int _currentIndex = 0;

  void _showNext() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _artworks.length;
    });
  }

  void _showPrevious() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _artworks.length) % _artworks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final artwork = _artworks[_currentIndex];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Expanded(
                flex: 5,
                child: Center(child: ArtworkWall(artwork: artwork)),
              ),
              const SizedBox(height: 32),
              ArtworkDescriptor(artwork: artwork),
              const SizedBox(height: 24),
              DisplayController(
                onPrevious: _showPrevious,
                onNext: _showNext,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

/// The "artwork wall": a framed, matted panel that displays the current
/// piece front and center.
class ArtworkWall extends StatelessWidget {
  const ArtworkWall({super.key, required this.artwork});

  final Artwork artwork;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black87, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: CustomPaint(
          painter: AbstractArtPainter(style: artwork.style, palette: artwork.palette),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

/// The "artwork descriptor": title, artist, and year of the current piece.
class ArtworkDescriptor extends StatelessWidget {
  const ArtworkDescriptor({super.key, required this.artwork});

  final Artwork artwork;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDE8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            artwork.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                artwork.artist,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(' (${artwork.year})', style: const TextStyle(fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }
}

/// The "display controller": buttons that move through the collection.
class DisplayController extends StatelessWidget {
  const DisplayController({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 120,
          child: ElevatedButton(onPressed: onPrevious, child: const Text('Previous')),
        ),
        SizedBox(
          width: 120,
          child: ElevatedButton(onPressed: onNext, child: const Text('Next')),
        ),
      ],
    );
  }
}

/// Paints a small abstract composition so each artwork looks distinct
/// without depending on bundled image assets.
class AbstractArtPainter extends CustomPainter {
  AbstractArtPainter({required this.style, required this.palette});

  final ArtStyle style;
  final List<Color> palette;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = palette.last.withOpacity(0.15);
    canvas.drawRect(Offset.zero & size, background);

    switch (style) {
      case ArtStyle.waves:
        _paintWaves(canvas, size);
        break;
      case ArtStyle.triangles:
        _paintTriangles(canvas, size);
        break;
      case ArtStyle.circles:
        _paintCircles(canvas, size);
        break;
      case ArtStyle.stripes:
        _paintStripes(canvas, size);
        break;
    }
  }

  void _paintWaves(Canvas canvas, Size size) {
    for (var i = 0; i < 3; i++) {
      final paint = Paint()..color = palette[i % palette.length];
      final path = Path()..moveTo(0, size.height * (0.3 + i * 0.2));
      path.quadraticBezierTo(
        size.width * 0.5,
        size.height * (0.1 + i * 0.2),
        size.width,
        size.height * (0.3 + i * 0.2),
      );
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  void _paintTriangles(Canvas canvas, Size size) {
    const rows = 4;
    const cols = 4;
    final cellW = size.width / cols;
    final cellH = size.height / rows;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final paint = Paint()..color = palette[(r + c) % palette.length];
        final path = Path()
          ..moveTo(c * cellW, r * cellH)
          ..lineTo((c + 1) * cellW, r * cellH)
          ..lineTo(c * cellW, (r + 1) * cellH)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  void _paintCircles(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.shortestSide / 2;
    for (var i = 5; i >= 1; i--) {
      final paint = Paint()..color = palette[i % palette.length];
      canvas.drawCircle(center, maxRadius * i / 5, paint);
    }
  }

  void _paintStripes(Canvas canvas, Size size) {
    const stripeCount = 6;
    final stripeWidth = size.width / stripeCount;
    for (var i = 0; i < stripeCount; i++) {
      final paint = Paint()..color = palette[i % palette.length];
      canvas.drawRect(
        Rect.fromLTWH(i * stripeWidth, 0, stripeWidth, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AbstractArtPainter oldDelegate) {
    return oldDelegate.style != style || oldDelegate.palette != palette;
  }
}
