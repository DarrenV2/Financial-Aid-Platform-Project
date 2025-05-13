// Ultimate AI Chat Widget
// Features:
// - Stylish design
// - Bot avatar animation (Lottie)
// - Voice input support (Speech-to-text)
// - Typing simulation with delay
// - Quick replies
// - Custom chat bubbles with avatars

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class UltimateAIChat extends StatefulWidget {
const UltimateAIChat({super.key});

@override
State<UltimateAIChat> createState() => \_UltimateAIChatState();
}

class \_UltimateAIChatState extends State<UltimateAIChat> {
final List<Map<String, dynamic>> \_messages = [];
final TextEditingController \_controller = TextEditingController();
bool \_isTyping = false;
late stt.SpeechToText \_speech;
bool \_isListening = false;

@override
void initState() {
super.initState();
\_speech = stt.SpeechToText();
}

void \_sendMessage(String text) async {
setState(() {
\_messages.add({'text': text, 'isUser': true});
\_isTyping = true;
});

    await Future.delayed(Duration(milliseconds: 500));

    String response = await _simulateTypingResponse(text);

    setState(() {
      _messages.add({'text': response, 'isUser': false});
      _isTyping = false;
    });

    _controller.clear();

}

Future<String> \_simulateTypingResponse(String userText) async {
String response = 'Mi hear yuh: "$userText". Mi deh yah fi help.';
await Future.delayed(Duration(seconds: 2));
return response;
}

void \_startListening() async {
if (!\_isListening) {
bool available = await \_speech.initialize();
if (available) {
setState(() => \_isListening = true);
\_speech.listen(onResult: (val) {
\_controller.text = val.recognizedWords;
});
}
} else {
setState(() => \_isListening = false);
\_speech.stop();
}
}

Widget \_chatBubble(String message, bool isUser) {
return Align(
alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
child: Container(
margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
padding: EdgeInsets.all(12),
decoration: BoxDecoration(
color: isUser ? Colors.green.shade300 : Colors.blue.shade100,
borderRadius: BorderRadius.only(
topLeft: Radius.circular(16),
topRight: Radius.circular(16),
bottomLeft: Radius.circular(isUser ? 16 : 0),
bottomRight: Radius.circular(isUser ? 0 : 16),
),
),
child: Text(message, style: TextStyle(fontSize: 16)),
),
);
}

Widget \_quickReplies() {
final replies = ['What can you do?', 'Tell me a joke', 'Translate this', 'Help me focus'];
return Wrap(
spacing: 8,
children: replies.map((reply) {
return ActionChip(
label: Text(reply),
onPressed: () => \_sendMessage(reply),
backgroundColor: Colors.blue.shade50,
);
}).toList(),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.grey.shade100,
appBar: AppBar(
title: Row(
children: [
CircleAvatar(
radius: 20,
backgroundColor: Colors.white,
child: Lottie.asset('assets/animations/chatbot.json', width: 36),
),
SizedBox(width: 10),
Text('IrieBot AI', style: TextStyle(fontWeight: FontWeight.bold)),
],
),
backgroundColor: Colors.deepPurple,
foregroundColor: Colors.white,
),
body: Column(
children: [
Expanded(
child: ListView.builder(
reverse: true,
padding: EdgeInsets.all(8),
itemCount: \_messages.length + (\_isTyping ? 1 : 0),
itemBuilder: (context, index) {
if (\_isTyping && index == 0) {
return \_chatBubble("Typing...", false);
}
final msg = \_messages[_messages.length - 1 - index];
return \_chatBubble(msg['text'], msg['isUser']);
},
),
),
Divider(height: 1),
Padding(
padding: const EdgeInsets.all(8.0),
child: Column(
children: [
\_quickReplies(),
Row(
children: [
IconButton(
icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
onPressed: _startListening,
),
Expanded(
child: TextField(
controller: _controller,
textInputAction: TextInputAction.send,
decoration: InputDecoration(
hintText: 'Ask mi anything...',
filled: true,
fillColor: Colors.white,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(24),
borderSide: BorderSide.none,
),
contentPadding:
EdgeInsets.symmetric(horizontal: 16, vertical: 12),
),
onSubmitted: (value) {
if (value.trim().isNotEmpty) _sendMessage(value.trim());
},
),
),
SizedBox(width: 8),
IconButton(
icon: Icon(Icons.send, color: Colors.deepPurple),
onPressed: () {
final text = _controller.text.trim();
if (text.isNotEmpty) _sendMessage(text);
},
),
],
),
],
),
)
],
),
);
}
}
