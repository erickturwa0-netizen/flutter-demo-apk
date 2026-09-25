import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mziki · Movie · Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class MediaItem {
  final String title;
  final String subtitle;
  final String? imageUrl;

  MediaItem({required this.title, required this.subtitle, this.imageUrl});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<_TabConfig> _tabs = const [
    _TabConfig(
      title: 'Mziki',
      icon: Icons.music_note_rounded,
      color: Color(0xFFE91E63),
      endpoint: 'https://itunes.apple.com/search?term=afrobeats&media=music&limit=20',
    ),
    _TabConfig(
      title: 'Movie',
      icon: Icons.movie_rounded,
      color: Color(0xFF00BCD4),
      endpoint: 'https://api.tvmaze.com/shows',
    ),
    _TabConfig(
      title: 'Game',
      icon: Icons.sports_esports_rounded,
      color: Color(0xFF4CAF50),
      endpoint: 'https://www.freetogame.com/api/games',
    ),
  ];

  // Cache data per tab
  final Map<int, List<MediaItem>> _cache = {};
  final Map<int, bool> _loading = {0: false, 1: false, 2: false};
  final Map<int, String?> _error = {0: null, 1: null, 2: null};

  @override
  void initState() {
    super.initState();
    _loadData(0);
  }

  Future<void> _loadData(int index) async {
    if (_cache.containsKey(index) || (_loading[index] ?? false)) return;

    setState(() {
      _loading[index] = true;
      _error[index] = null;
    });

    try {
      final config = _tabs[index];
      final response = await http.get(Uri.parse(config.endpoint)).timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode != 200) {
        throw Exception('Status ${response.statusCode}');
      }

      final List<MediaItem> items = [];
      final body = jsonDecode(response.body);

      if (index == 0) {
        // iTunes Music
        final results = body['results'] as List? ?? [];
        for (final r in results) {
          items.add(MediaItem(
            title: r['trackName']?.toString() ?? r['collectionName']?.toString() ?? 'Unknown',
            subtitle: r['artistName']?.toString() ?? '',
            imageUrl: r['artworkUrl100']?.toString().replaceAll('100x100', '200x200'),
          ));
        }
      } else if (index == 1) {
        // TVMaze Shows (as movies/series)
        final results = body as List? ?? [];
        for (final r in results.take(25)) {
          final image = r['image'];
          items.add(MediaItem(
            title: r['name']?.toString() ?? 'Unknown',
            subtitle: r['genres'] is List
                ? (r['genres'] as List).join(', ')
                : (r['type']?.toString() ?? ''),
            imageUrl: image is Map ? image['medium']?.toString() : null,
          ));
        }
      } else {
        // FreeToGame
        final results = body as List? ?? [];
        for (final r in results.take(30)) {
          items.add(MediaItem(
            title: r['title']?.toString() ?? 'Unknown',
            subtitle: r['genre']?.toString() ?? r['platform']?.toString() ?? '',
            imageUrl: r['thumbnail']?.toString(),
          ));
        }
      }

      if (mounted) {
        setState(() {
          _cache[index] = items;
          _loading[index] = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error[index] = e.toString();
          _loading[index] = false;
        });
      }
    }
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _loadData(index);
  }

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[_currentIndex];
    final items = _cache[_currentIndex] ?? [];
    final isLoading = _loading[_currentIndex] ?? false;
    final error = _error[_currentIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A2E),
              tab.color.withOpacity(0.22),
              const Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: tab.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(tab.icon, color: tab.color, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tab.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Data kutoka API',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLoading)
                      IconButton(
                        onPressed: () {
                          _cache.remove(_currentIndex);
                          _loadData(_currentIndex);
                        },
                        icon: Icon(Icons.refresh_rounded, color: tab.color),
                      ),
                  ],
                ),
              ),

              // Endpoint badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: tab.color.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: tab.color.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'GET',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: tab.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tab.endpoint,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.5),
                            fontFamily: 'monospace',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Content
              Expanded(
                child: isLoading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: tab.color),
                            const SizedBox(height: 16),
                            Text(
                              'Inapakia ${tab.title.toLowerCase()}...',
                              style: TextStyle(color: Colors.white.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      )
                    : error != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.cloud_off_rounded, size: 48, color: tab.color.withOpacity(0.6)),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Imeshindwa kupakia data',
                                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    error,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _cache.remove(_currentIndex);
                                      _loadData(_currentIndex);
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Jaribu tena'),
                                    style: ElevatedButton.styleFrom(backgroundColor: tab.color),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : items.isEmpty
                            ? Center(
                                child: Text(
                                  'Hakuna data',
                                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                                itemCount: items.length,
                                itemBuilder: (context, i) {
                                  final item = items[i];
                                  return _MediaCard(
                                    index: i + 1,
                                    item: item,
                                    accent: tab.color,
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F1A),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.transparent,
          indicatorColor: tab.color.withOpacity(0.25),
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          destinations: _tabs.map((t) {
            return NavigationDestination(
              icon: Icon(t.icon, color: Colors.white54),
              selectedIcon: Icon(t.icon, color: t.color),
              label: t.title,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TabConfig {
  final String title;
  final IconData icon;
  final Color color;
  final String endpoint;

  const _TabConfig({
    required this.title,
    required this.icon,
    required this.color,
    required this.endpoint,
  });
}

class _MediaCard extends StatelessWidget {
  final int index;
  final MediaItem item;
  final Color accent;

  const _MediaCard({
    required this.index,
    required this.item,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.imageUrl != null
                ? Image.network(
                    item.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: 60,
                        height: 60,
                        color: accent.withOpacity(0.15),
                        child: Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: accent),
                          ),
                        ),
                      );
                    },
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#$index',
                  style: TextStyle(fontSize: 11, color: accent, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.25)),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 60,
      height: 60,
      color: accent.withOpacity(0.2),
      child: Icon(Icons.image, color: accent, size: 28),
    );
  }
}
