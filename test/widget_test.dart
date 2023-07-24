import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart';

import 'package:emotion_gram/main.dart';

class MockCameraDescription extends CameraDescription {
  const MockCameraDescription({
    required String name,
    required CameraLensDirection lensDirection,
    required int sensorOrientation,
  }) : super(
          name: name,
          lensDirection: lensDirection,
          sensorOrientation: sensorOrientation,
        );
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create a mock CameraDescription instance
    final mockCamera = MockCameraDescription(
      name: 'mockCamera',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(camera: mockCamera));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
