import 'package:flutter_test/flutter_test.dart';
import 'package:main/domain/liked_cats_provider.dart';
import 'package:main/data/cat_model.dart';
import 'package:main/data/liked_cats_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DummyStorage extends LikedCatsStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  late LikedCatsNotifier notifier;

  final Cat testCat = Cat(
    imageUrl: 'https://example.com/cat.jpg',
    breedName: 'Maine Coon',
    breedDescription: 'Large and friendly cat',
  );

  setUp(() {
    notifier = LikedCatsNotifier(DummyStorage());
  });

  test('лайкает кота один раз', () {
    notifier.likeCat(testCat);

    expect(notifier.likedCats.length, 1);
    expect(notifier.likedCats.first.imageUrl, testCat.imageUrl);
  });

  test('повторный лайк не добавляет дубликат', () {
    notifier.likeCat(testCat);
    notifier.likeCat(testCat);

    expect(notifier.likedCats.length, 1);
  });

  test('удаление кота по imageUrl', () {
    notifier.likeCat(testCat);
    notifier.removeCat(testCat.imageUrl);

    expect(notifier.likedCats, isEmpty);
  });

  test('очистка всех лайков', () {
    notifier.likeCat(testCat);
    notifier.clear();

    expect(notifier.likedCats, isEmpty);
  });

  test('фильтрация по породе', () {
    final cat2 = Cat(
      imageUrl: 'https://example.com/cat2.jpg',
      breedName: 'Siamese',
      breedDescription: 'Elegant and talkative cat',
    );

    notifier.likeCat(testCat);
    notifier.likeCat(cat2);

    final filtered = notifier.filterByBreed('Maine Coon');
    expect(filtered.length, 1);
    expect(filtered.first.imageUrl, testCat.imageUrl);
  });

  test('получение списка пород', () {
    final cat2 = Cat(
      imageUrl: 'https://example.com/cat2.jpg',
      breedName: 'Siamese',
      breedDescription: 'Elegant and talkative cat',
    );

    notifier.likeCat(testCat);
    notifier.likeCat(cat2);

    final breeds = notifier.getBreeds();
    expect(breeds, containsAll(['Maine Coon', 'Siamese']));
  });
}
