import 'package:flutter_test/flutter_test.dart';

import 'package:earnbucks/main.dart';

void main() {
  testWidgets('Home screen renders the balance hero card', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskBucksApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Total balance'), findsOneWidget);
  });
}
