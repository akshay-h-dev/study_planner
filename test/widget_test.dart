
import 'package:flutter_test/flutter_test.dart';
import 'package:study_planner/main.dart';

void main() {
  testWidgets('Study Planner starter screen is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudyPlannerApp());

    expect(find.text('Study Planner'), findsOneWidget);
    expect(find.text('Plan your learning journey'), findsOneWidget);
    expect(find.text('Flutter project setup'), findsOneWidget);
  });
}
