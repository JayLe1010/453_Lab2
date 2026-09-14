import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:art_space/main.dart';

void main() {
  testWidgets('Next and Previous buttons cycle through artworks', (tester) async {
    await tester.pumpWidget(const ArtSpaceApp());

    expect(find.text('Sunset Waves'), findsOneWidget);
    expect(find.text('Alex Rivera'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(find.text('Geometric Bloom'), findsOneWidget);

    await tester.tap(find.text('Previous'));
    await tester.pump();
    expect(find.text('Sunset Waves'), findsOneWidget);

    // Previous from the first artwork should wrap around to the last one.
    await tester.tap(find.text('Previous'));
    await tester.pump();
    expect(find.text('Golden Fields'), findsOneWidget);
  });
}
