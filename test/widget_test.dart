import 'package:flutter_test/flutter_test.dart';
import 'package:kora_book/core/utils/breakpoints.dart';
import 'package:material_ui/material_ui.dart';

Future<WindowSize> _sizeFor(WidgetTester tester, double width) async {
  late WindowSize result;
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          result = context.windowSize;
          return const SizedBox();
        },
      ),
    ),
  );
  return result;
}

void main() {
  group('WindowSize', () {
    testWidgets('compact below 600', (tester) async {
      expect(await _sizeFor(tester, 599), WindowSize.compact);
    });

    testWidgets('medium from 600 to 839', (tester) async {
      expect(await _sizeFor(tester, 600), WindowSize.medium);
      expect(await _sizeFor(tester, 839), WindowSize.medium);
    });

    testWidgets('expanded from 840', (tester) async {
      expect(await _sizeFor(tester, 840), WindowSize.expanded);
    });
  });
}
