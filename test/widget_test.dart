// ============================================================
// ARQUIVO: test/widget_test.dart
// FUNÇÃO: Teste básico de fumaça (smoke test) da aplicação.
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:papacapim/main.dart';
import 'package:papacapim/providers/app_state.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const PapacapimApp(),
      ),
    );

    // Verifica se a tela inicial de Login do Papacapim foi renderizada
    expect(find.text('Papacapim'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
