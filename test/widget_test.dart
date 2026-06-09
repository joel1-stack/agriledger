import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agri_ledger/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const PoultryApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
