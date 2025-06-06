import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cat_card.dart';
import '../data/cat_api.dart';
import 'cat_action_buttons.dart';
import '../data/cat_model.dart';
import '../domain/liked_cats_provider.dart';
import 'liked_cats_screen.dart';
import '../data/liked_cats_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Основной экран приложения
class CatHomeScreen extends StatefulWidget {
  const CatHomeScreen({super.key});

  @override
  CatHomeScreenState createState() => CatHomeScreenState();
}

class CatHomeScreenState extends State<CatHomeScreen> {
  int _likeCount = 0;
  Cat? _currentCat;
  bool _isLoading = false;
  bool _interactionDisabled = false;
  late final Connectivity _connectivity;
  late final Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _setupConnectivity();
    _loadLikeCount();
    _fetchCat(); 
  }

  void _setupConnectivity() {
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;
    _connectivityStream.listen((result) async {
      final isOnline = result != ConnectivityResult.none;

      if (!mounted) return;

      if (isOnline) {
        setState(() => _interactionDisabled = false);

        if (_currentCat == null) {
          _fetchCat();
        }
      } else {
        setState(() => _interactionDisabled = true);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Нет подключения к сети'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  Future<void> _loadLikeCount() async {
    final storage = LikedCatsStorage();
    final count = await storage.loadLikeCounter();
    if (!mounted) return;
    setState(() {
      _likeCount = count;
    });
  }

  Future<void> _fetchCat() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    final status = await _connectivity.checkConnectivity();
    final hasInternet = status != ConnectivityResult.none;

    try {
      if (hasInternet) {
        final cat = await fetchCatWithBreed();
        if (!mounted) return;
        setState(() {
          _currentCat = cat;
          _interactionDisabled = false;
        });
      } else {
        if (!mounted) return;
        setState(() => _interactionDisabled = true);

        if (_currentCat == null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Коты закончились. Подключитесь к интернету.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _interactionDisabled = true);
      _showOfflineEmptyDialog();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showOfflineEmptyDialog() {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Оффлайн'),
        content: const Text('Коты закончились, а интернета нет'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  Future<void> _likeCat() async {
    if (_interactionDisabled || _currentCat == null) return;

    context.read<LikedCatsNotifier>().likeCat(_currentCat!);
    final newCount = _likeCount + 1;

    setState(() => _likeCount = newCount);

    final storage = LikedCatsStorage();
    await storage.saveLikeCounter(newCount);

    _fetchCat();
  }

  void _dislikeCat() {
    if (_interactionDisabled) return;
    _fetchCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/title.png', height: 40),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.favorite, size: 24),
                label: const Text(
                  'Лайкнутые коты',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LikedCatsScreen()),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      )
                    : CatCard(
                        imageUrl: _currentCat?.imageUrl ?? '',
                        breedName: _currentCat?.breedName ?? '',
                        breedDescription: _currentCat?.breedDescription ?? '',
                        onLike: _interactionDisabled ? null : _likeCat,
                        onDislike: _interactionDisabled ? null : _dislikeCat,
                        interactionDisabled: _interactionDisabled,
                      ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CatActionButtons(
        likeCount: _likeCount,
        onLike: _interactionDisabled ? null : _likeCat,
        onDislike: _interactionDisabled ? null : _dislikeCat,
      ),
    );
  }
}
