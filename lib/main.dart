import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;

  final List<_Section> _sections = const [
    _Section(
      title: 'Mziki',
      icon: Icons.music_note_rounded,
      color: Color(0xFFE91E63),
      endpoints: [
        _Endpoint('Deezer Chart', 'https://api.deezer.com/chart'),
        _Endpoint('Deezer Search', 'https://api.deezer.com/search?q=eminem'),
        _Endpoint('iTunes Search', 'https://itunes.apple.com/search?term=sauti+sol&media=music'),
        _Endpoint('Audius Tracks', 'https://discoveryprovider.audius.co/v1/tracks/trending'),
      ],
      items: [
        _Item(
          title: 'Sauti Sol - Suzanna',
          imageUrl: 'https://picsum.photos/seed/suzanna/200',
        ),
        _Item(
          title: 'Diamond Platnumz - Jeje',
          imageUrl: 'https://picsum.photos/seed/jeje/200',
        ),
        _Item(
          title: 'Burna Boy - Last Last',
          imageUrl: 'https://picsum.photos/seed/burna/200',
        ),
        _Item(
          title: 'Beyoncé - Cuff It',
          imageUrl: 'https://picsum.photos/seed/beyonce/200',
        ),
        _Item(
          title: 'Tems - Free Mind',
          imageUrl: 'https://picsum.photos/seed/tems/200',
        ),
      ],
    ),
    _Section(
      title: 'Movie',
      icon: Icons.movie_rounded,
      color: Color(0xFF00BCD4),
      endpoints: [
        _Endpoint('TMDB Popular', 'https://api.themoviedb.org/3/movie/popular'),
        _Endpoint('TMDB Top Rated', 'https://api.themoviedb.org/3/movie/top_rated'),
        _Endpoint('OMDb Search', 'https://www.omdbapi.com/?s=batman&apikey=YOUR_KEY'),
        _Endpoint('TVMaze Shows', 'https://api.tvmaze.com/shows'),
      ],
      items: [
        _Item(
          title: 'Inception (2010)',
          imageUrl: 'https://picsum.photos/seed/inception/200',
        ),
        _Item(
          title: 'The Dark Knight (2008)',
          imageUrl: 'https://picsum.photos/seed/darkknight/200',
        ),
        _Item(
          title: 'Black Panther (2018)',
          imageUrl: 'https://picsum.photos/seed/blackpanther/200',
        ),
        _Item(
          title: 'Avatar: The Way of Water',
          imageUrl: 'https://picsum.photos/seed/avatar/200',
        ),
        _Item(
          title: 'Oppenheimer (2023)',
          imageUrl: 'https://picsum.photos/seed/oppenheimer/200',
        ),
      ],
    ),
    _Section(
      title: 'Game',
      icon: Icons.sports_esports_rounded,
      color: Color(0xFF4CAF50),
      endpoints: [
        _Endpoint('FreeToGame All', 'https://www.freetogame.com/api/games'),
        _Endpoint('FreeToGame PC', 'https://www.freetogame.com/api/games?platform=pc'),
        _Endpoint('FreeToGame Browser', 'https://www.freetogame.com/api/games?platform=browser'),
        _Endpoint('RAWG Games', 'https://api.rawg.io/api/games'),
      ],
      items: [
        _Item(
          title: 'Genshin Impact',
          imageUrl: 'https://picsum.photos/seed/genshin/200',
        ),
        _Item(
          title: 'Fortnite',
          imageUrl: 'https://picsum.photos/seed/fortnite/200',
        ),
        _Item(
          title: 'Call of Duty: Warzone',
          imageUrl: 'https://picsum.photos/seed/warzone/200',
        ),
        _Item(
          title: 'Valorant',
          imageUrl: 'https://picsum.photos/seed/valorant/200',
        ),
        _Item(
          title: 'League of Legends',
          imageUrl: 'https://picsum.photos/seed/lol/200',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _fadeController.reset();
      _fadeController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final section = _sections[_currentIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A2E),
              section.color.withOpacity(0.25),
              const Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: section.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(section.icon, color: section.color, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Endpoints & Orodha',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeController,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    children: [
                      _buildSectionTitle('API Endpoints', Icons.link_rounded),
                      const SizedBox(height: 10),
                      ...section.endpoints.asMap().entries.map((entry) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 300 + (entry.key * 80)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: _EndpointCard(
                            endpoint: entry.value,
                            accent: section.color,
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                        section.title == 'Mziki'
                            ? 'Nyimbo Maarufu'
                            : section.title == 'Movie'
                                ? 'Filamu Maarufu'
                                : 'Michezo Maarufu',
                        Icons.star_rounded,
                      ),
                      const SizedBox(height: 10),
                      ...section.items.asMap().entries.map((entry) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 350 + (entry.key * 70)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(30 * (1 - value), 0),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: _ItemCard(
                            index: entry.key + 1,
                            item: entry.value,
                            accent: section.color,
                          ),
                        );
                      }),
                    ],
                  ),
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
          indicatorColor: section.color.withOpacity(0.25),
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: _sections.map((s) {
            return NavigationDestination(
              icon: Icon(s.icon, color: Colors.white54),
              selectedIcon: Icon(s.icon, color: s.color),
              label: s.title,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white70),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _Section {
  final String title;
  final IconData icon;
  final Color color;
  final List<_Endpoint> endpoints;
  final List<_Item> items;

  const _Section({
    required this.title,
    required this.icon,
    required this.color,
    required this.endpoints,
    required this.items,
  });
}

class _Endpoint {
  final String name;
  final String url;

  const _Endpoint(this.name, this.url);
}

class _Item {
  final String title;
  final String imageUrl;

  const _Item({required this.title, required this.imageUrl});
}

class _EndpointCard extends StatelessWidget {
  final _Endpoint endpoint;
  final Color accent;

  const _EndpointCard({required this.endpoint, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'GET',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  endpoint.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            endpoint.url,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.55),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final int index;
  final _Item item;
  final Color accent;

  const _ItemCard({
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
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: accent.withOpacity(0.25),
                child: Icon(Icons.image, color: accent, size: 28),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 56,
                  height: 56,
                  color: accent.withOpacity(0.15),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: accent,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // Number + Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#$index',
                  style: TextStyle(
                    fontSize: 11,
                    color: accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.3)),
        ],
      ),
    );
  }
}
