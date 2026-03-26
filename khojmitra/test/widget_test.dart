import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khojmitra/screens/main_wrapper.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainWrapper(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}