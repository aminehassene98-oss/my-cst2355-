import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_labs/main.dart';
import 'package:my_flutter_labs/repository.dart';

void main() {
  testWidgets('App loads Login Page', (WidgetTester tester) async {
    final repo = Repository(); // no const needed

    await tester.pumpWidget(MyApp(repo));
    await tester.pump(); // let first frame settle

    // Your Login page shows these texts
    expect(find.text('Login Page'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}