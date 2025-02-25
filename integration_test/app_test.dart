import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;
import 'package:restaurant_app/screen/favorite/favorite_screen.dart';
import 'package:restaurant_app/screen/main/main_screen.dart';
import 'package:restaurant_app/screen/setting/setting_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Navigasi antar layar', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(seconds: 5));

    // Memastikan kita berada di layar utama
    expect(find.byType(MainScreen), findsOneWidget);
    print('Berada di layar utama');

    // Tap pada tombol Favorite
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byType(FavoriteScreen), findsOneWidget);
    print('Berada di layar Favorite');

    // Tap pada tombol Setting
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byType(SettingScreen), findsOneWidget);
    print('Berada di layar Setting');

    // Kembali ke layar utama
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle(Duration(seconds: 5));
    expect(find.byType(MainScreen), findsOneWidget);
    print('Kembali ke layar utama');
  });
}