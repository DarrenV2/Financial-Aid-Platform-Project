import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:financial_aid_project/utils/constants/api_keys.dart';
import 'package:financial_aid_project/utils/constants/chatbot_prompts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class GeminiChatbotController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString chatResponse = ''.obs;
  final RxBool isChatOpen = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController inputController = TextEditingController();
  final RxBool isTyping = false.obs;
  final RxBool isListening = false.obs;
  late stt.SpeechToText speech;

  // Chat window size controls
  final RxDouble chatHeight = 450.0.obs;
  final RxDouble chatWidth = 320.0.obs;
  final RxBool isResizing = false.obs;

  // Use API key from constants
  final String apiKey = ApiKeys.geminiApiKey;
  late final GenerativeModel model;

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
    try {
      model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
      // Add welcome message
      messages.add(ChatMessage(
        text: 'How can I help you with scholarships today?',
        isUser: false,
      ));
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to initialize Gemini: $e';
    }
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    final String userQuery = userMessage;

    // Add user message to chat history
    messages.add(ChatMessage(
      text: userQuery,
      isUser: true,
    ));

    isLoading.value = true;
    isTyping.value = true;
    hasError.value = false;
    inputController.clear();

    // Add temporary bot response showing typing status
    final int tempIndex = messages.length;
    messages.add(ChatMessage(
      text: 'Typing...',
      isUser: false,
    ));

    try {
      // Use the enhanced context prompt
      final String contextPrompt =
          ChatbotPrompts.getScholarshipContextPrompt(userQuery);

      final content = [Content.text(contextPrompt)];

      // Simulate typing delay for better UX
      await Future.delayed(const Duration(milliseconds: 800));

      final response = await model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        // Update the temporary message with the actual response
        if (tempIndex < messages.length) {
          messages[tempIndex] = ChatMessage(
            text: response.text!,
            isUser: false,
          );
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Received empty response';

        // Update with error message
        if (tempIndex < messages.length) {
          messages[tempIndex] = ChatMessage(
            text: 'Sorry, I couldn\'t generate a response. Please try again.',
            isUser: false,
          );
        }
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();

      // Update with error message
      if (tempIndex < messages.length) {
        messages[tempIndex] = ChatMessage(
          text:
              'I encountered an error. Please check your network connection or try again later.',
          isUser: false,
        );
      }
    } finally {
      isLoading.value = false;
      isTyping.value = false;
    }
  }

  void toggleChat() {
    isChatOpen.value = !isChatOpen.value;

    // If opening the chat, make sure speech is stopped
    if (isChatOpen.value && isListening.value) {
      stopListening();
    }
  }

  void clearChat() {
    messages.clear();
    messages.add(ChatMessage(
      text: 'How can I help you with scholarships today?',
      isUser: false,
    ));
  }

  void startListening() async {
    if (!isListening.value) {
      bool available = await speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
      );
      if (available) {
        isListening.value = true;
        speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              inputController.text = result.recognizedWords;
              if (result.recognizedWords.isNotEmpty) {
                // Auto-send if we have a final result
                sendMessage(result.recognizedWords);
                isListening.value = false;
              }
            } else {
              inputController.text = result.recognizedWords;
            }
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        );
      }
    } else {
      stopListening();
    }
  }

  void stopListening() {
    speech.stop();
    isListening.value = false;
  }

  void startResizing() {
    isResizing.value = true;
  }

  void stopResizing() {
    isResizing.value = false;
  }

  void updateChatSize(double width, double height) {
    if (width > 250) chatWidth.value = width;
    if (height > 350) chatHeight.value = height;
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}

class GeminiChatbot extends StatelessWidget {
  const GeminiChatbot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GeminiChatbotController());

    return Obx(() {
      return Stack(
        children: [
          // Chat panel
          if (controller.isChatOpen.value)
            Positioned(
              bottom: 80,
              right: 20,
              child: _buildResizableChat(controller, context),
            ),

          // Floating chat button with animation
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: TColors.primary.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                elevation: 4,
                color: Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: controller.toggleChat,
                  child: controller.isChatOpen.value
                      ? Icon(Icons.close, color: TColors.primary, size: 32)
                      : Container(
                          width: 70,
                          height: 70,
                          padding: EdgeInsets.zero,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: Lottie.asset(
                            'assets/images/animations/Round-AI-Purple-Animation.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildResizableChat(
      GeminiChatbotController controller, BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          // Main chat container
          Container(
            width: controller.chatWidth.value,
            height: controller.chatHeight.value,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Chat header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Lottie.asset(
                            'assets/images/animations/Round-AI-Purple-Animation.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: const Text(
                            'Scholarship Assistant',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.white, size: 20),
                          onPressed: controller.clearChat,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Clear chat',
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                          onPressed: controller.toggleChat,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                  ),

                  // Chat response area
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: controller.messages.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                    ),
                                    child: Lottie.asset(
                                      'assets/images/animations/Round-AI-Purple-Animation.json',
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Ask me anything about scholarships!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: controller.messages.length,
                              itemBuilder: (context, index) {
                                final message = controller.messages[
                                    controller.messages.length - 1 - index];
                                return MessageBubble(message: message);
                              },
                            ),
                    ),
                  ),

                  // Quick replies section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildQuickReplies(controller),
                  ),

                  // Loading indicator
                  if (controller.isLoading.value)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),

                  // Input area
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            controller.isListening.value
                                ? Icons.mic
                                : Icons.mic_none,
                            color: controller.isListening.value
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: controller.startListening,
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.inputController,
                            decoration: InputDecoration(
                              hintText: 'Ask about scholarships...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            maxLines: 1,
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                controller.sendMessage(value.trim());
                              }
                            },
                            enabled: !controller.isLoading.value,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: TColors.primary),
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  final text =
                                      controller.inputController.text.trim();
                                  if (text.isNotEmpty) {
                                    controller.sendMessage(text);
                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Diagonal resize handle in the top-left corner
          Positioned(
            left: 0,
            top: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                controller.updateChatSize(
                  controller.chatWidth.value - details.delta.dx,
                  controller.chatHeight.value - details.delta.dy,
                );
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                  ),
                ),
                child: Transform.rotate(
                  angle: 3.14159, // 180 degrees in radians
                  child: Icon(
                    Icons.drag_handle,
                    color: TColors.primary.withOpacity(0.7),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          // Vertical resize handle at the top
          Positioned(
            left: 50,
            right: 50,
            top: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                controller.updateChatSize(
                  controller.chatWidth.value,
                  controller.chatHeight.value - details.delta.dy,
                );
              },
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: TColors.primary.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Horizontal resize handle on the left
          Positioned(
            left: 0,
            top: 50,
            bottom: 50,
            child: GestureDetector(
              onPanUpdate: (details) {
                controller.updateChatSize(
                  controller.chatWidth.value - details.delta.dx,
                  controller.chatHeight.value,
                );
              },
              child: Container(
                width: 8,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TColors.primary.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildQuickReplies(GeminiChatbotController controller) {
    final quickReplies = [
      'How do I apply?',
      'Eligibility criteria?',
      'Application deadlines',
      'Required documents',
      'Tell me about scholarships',
    ];

    return Wrap(
      spacing: 8,
      children: quickReplies.map((reply) {
        return ActionChip(
          avatar:
              Icon(Icons.lightbulb_outline, size: 18, color: TColors.primary),
          label: Text(reply, style: const TextStyle(fontSize: 12)),
          backgroundColor: TColors.primary.withOpacity(0.1),
          side: BorderSide(color: TColors.primary.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          onPressed: () => controller.sendMessage(reply),
        );
      }).toList(),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Lottie.asset(
                'assets/images/animations/Round-AI-Purple-Animation.json',
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
          if (message.isUser) const Spacer(),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: message.isUser ? 0 : 8,
                right: message.isUser ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser
                    ? TColors.primary.withOpacity(0.1)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isUser ? 16 : 0),
                  bottomRight: Radius.circular(message.isUser ? 0 : 16),
                ),
                border: message.isUser
                    ? Border.all(color: TColors.primary.withOpacity(0.3))
                    : null,
              ),
              child: message.text == 'Typing...'
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Typing',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildTypingIndicator(),
                      ],
                    )
                  : Text(
                      message.text,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          if (!message.isUser) const Spacer(),
          if (message.isUser)
            const CircleAvatar(
              radius: 18,
              backgroundColor: TColors.primary,
              child: Icon(
                Icons.person,
                size: 18,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return SizedBox(
      width: 40,
      child: Row(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _buildDot(index),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 * (index + 1)),
      builder: (context, double value, child) {
        return Container(
          margin: const EdgeInsets.only(top: 5),
          height: 5 + (value * 3),
          width: 5 + (value * 3),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      },
    );
  }
}
