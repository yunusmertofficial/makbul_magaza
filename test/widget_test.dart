import 'package:flutter_test/flutter_test.dart';
import 'package:makbul_magaza/main.dart';

void main() {
  testWidgets('Makbul Mağazası smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MakbulApp());
    expect(find.text('Makbul Mağazası'), findsOneWidget);
  });
}
