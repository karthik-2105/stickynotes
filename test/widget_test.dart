import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sticky_note_app/main.dart';

void main() {
  testWidgets('Sticky Note renders and accepts input', (WidgetTester tester) async {
    await tester.pumpWidget(const StickyNoteApp());

    // Wait for widgets to settle
    await tester.pumpAndSettle();

    // Verify the hint text exists
    expect(find.text('Write your note here...'), findsOneWidget);

    // Enter some text
    await tester.enterText(find.byType(TextField), 'Test Note');
    await tester.pumpAndSettle();

    // Verify the text was entered
    expect(find.text('Test Note'), findsOneWidget);

    // Drag the slider right to increase transparency
    await tester.drag(find.byType(Slider), const Offset(100, 0));
    await tester.pumpAndSettle();

    // Slider exists
    expect(find.byType(Slider), findsOneWidget);
  });
}
