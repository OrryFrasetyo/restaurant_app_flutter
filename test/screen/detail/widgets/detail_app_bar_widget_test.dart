import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/screen/detail/detail_app_bar_widget.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

void main() {
  testWidgets('detail app bar widget has the correct widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: DetailAppBarWidget(),
        ),
      ),
    );

    expect(find.text('Restaurant Detail'), findsOneWidget);

    final textWidget =
        tester.firstWidget(find.text('Restaurant Detail')) as Text;

    expect(textWidget.style?.color, RestaurantColors.onPrimary.color);
    expect(textWidget.style?.fontSize,
        RestaurantTextStyles.headlineSmall.fontSize);

    final appBar = tester.firstWidget(find.byType(AppBar)) as AppBar;

    expect(appBar.backgroundColor, RestaurantColors.primary.color);

    final appBarShape = appBar.shape as RoundedRectangleBorder;
    final borderRadius = appBarShape.borderRadius as BorderRadius;

    expect(borderRadius.bottomLeft.x, 12.0);
    expect(borderRadius.bottomRight.x, 12.0);
  });
}
