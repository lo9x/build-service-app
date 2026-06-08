import 'package:build_service_app/shared/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SectionCard renders child content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionCard(
            child: Text('Demo card'),
          ),
        ),
      ),
    );

    expect(find.text('Demo card'), findsOneWidget);
  });
}
