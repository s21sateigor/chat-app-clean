import 'package:chatapp_firebase/widgets/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MessageTile parāda ziņu un ziņas autoru',
      (WidgetTester tester) async {
    const testMessage = "Sveiks, šī ir testa ziņa";
    const testSender = "Jānis Bērziņš";
    const bool sentByMe = true;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageTile(
            message: testMessage,
            sender: testSender,
            sentByMe: sentByMe,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        ),
      ),
    );

    final messageText = tester.firstWidget<Text>(find.text(testMessage));
    final senderText = tester.firstWidget<Text>(find.text(testSender.toUpperCase()));

    expect(messageText, isNotNull);
    expect(senderText, isNotNull);
    expect(messageText.data, testMessage);
    expect(senderText.data, testSender.toUpperCase());
  });
}
