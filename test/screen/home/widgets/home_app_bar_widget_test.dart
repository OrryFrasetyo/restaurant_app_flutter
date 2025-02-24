import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/screen/home/home_app_bar_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

void main() {
  testWidgets('home app bar widget test has the correct widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: HomeAppBarWidget(),
        ),
        routes: {
          NavigationRoute.searchRoute.name: (_) => Container(),
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Restaurantqu'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('Recommendation restaurant for you!'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.byType(Container), findsOneWidget);
  });
}
