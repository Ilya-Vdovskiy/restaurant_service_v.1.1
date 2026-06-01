import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_flutter_app/main.dart';

void main() {
  testWidgets('app starts with splash screen', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: RestaurantTrainingApp()),
    );

    expect(find.text('Restaurant Academy'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Добро пожаловать'), findsOneWidget);
  });
}
