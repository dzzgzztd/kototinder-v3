import 'package:flutter/material.dart';
import 'presentation/cat_home_screen.dart';
import 'package:provider/provider.dart';
import 'domain/liked_cats_provider.dart';
import 'di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();

  final likedCatsNotifier = getIt<LikedCatsNotifier>();
  await likedCatsNotifier.load(); 

  runApp(
    ChangeNotifierProvider<LikedCatsNotifier>.value(
      value: likedCatsNotifier,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CatHomeScreen(),
    );
  }
}
