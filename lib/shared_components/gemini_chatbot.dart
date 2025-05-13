import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:financial_aid_project/utils/constants/colors.dart';
import 'package:financial_aid_project/utils/constants/api_keys.dart';
import 'package:financial_aid_project/utils/constants/chatbot_prompts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart' as stt_result;
import 'package:flutter/foundation.dart' show kIsWeb;

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

  // Use API key from constants
  final String apiKey = ApiKeys.geminiApiKey;
  late final GenerativeModel model;

  final RxBool speechAvailable = false.obs;
  final RxString permissionStatus = 'Not initialized'.obs;

  // Add constant for welcome message to avoid duplication
  static const String _welcomeMessage =
      'How can I help you with scholarships today?';

  @override
  void onInit() {
    super.onInit();
    _initializeComponents();
  }

  Future<void> _initializeComponents() async {
    speech = stt.SpeechToText();
    _initializeSpeech();
    _initializeGemini();
  }

  void _initializeGemini() {
    try {
      model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
      // Add welcome message
      messages.add(ChatMessage(
        text: _welcomeMessage,
        isUser: false,
      ));
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to initialize Gemini: $e';
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      if (kIsWeb) {
        // Web-specific initialization
        speechAvailable.value = await speech.initialize(
          onStatus: _handleSpeechStatus,
          onError: _handleSpeechError,
          debugLogging: true,
        );
      } else {
        // Mobile initialization
        speechAvailable.value = await speech.initialize(
          onStatus: _handleSpeechStatus,
        );
      }
    } catch (e) {
      speechAvailable.value = false;
      permissionStatus.value = 'Error initializing: $e';
    }
  }

  void _handleSpeechStatus(String status) {
    permissionStatus.value = status;
    if (status == 'done' || status == 'notListening') {
      isListening.value = false;
    } else if (status == 'error') {
      isListening.value = false;
      Get.snackbar(
        'Speech Recognition Error',
        'An error occurred with speech recognition.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromRGBO(244, 67, 54, 0.7),
        colorText: Colors.white,
      );
    }
  }

  void _handleSpeechError(dynamic error) {
    permissionStatus.value = 'Error: $error';
    isListening.value = false;

    if (error.errorMsg.contains('permission') ||
        error.errorMsg.contains('denied')) {
      Get.snackbar(
        'Permission Denied',
        'Please allow microphone permission to use voice input.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromRGBO(255, 152, 0, 0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> sendMessage(String userMessage) async {
    final String trimmedMessage = userMessage.trim();
    if (trimmedMessage.isEmpty) return;

    // Add user message to chat history
    messages.add(ChatMessage(
      text: trimmedMessage,
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
          ChatbotPrompts.getScholarshipContextPrompt(trimmedMessage);

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
        _handleEmptyResponse(tempIndex);
      }
    } catch (e) {
      _handleResponseError(tempIndex, e.toString());
    } finally {
      isLoading.value = false;
      isTyping.value = false;
    }
  }

  void _handleEmptyResponse(int tempIndex) {
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

  void _handleResponseError(int tempIndex, String error) {
    hasError.value = true;
    errorMessage.value = error;

    // Update with error message
    if (tempIndex < messages.length) {
      messages[tempIndex] = ChatMessage(
        text:
            'I encountered an error. Please check your network connection or try again later.',
        isUser: false,
      );
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
      text: _welcomeMessage,
      isUser: false,
    ));
  }

  Future<void> startListening() async {
    // Don't attempt to start if already listening
    if (isListening.value) {
      stopListening();
      return;
    }

    // Set a flag to prevent multiple rapid calls
    isListening.value = true;

    try {
      if (!speechAvailable.value) {
        await _initializeSpeech();
        if (!speechAvailable.value) {
          _showSpeechUnavailableMessage();
          return;
        }
      }

      try {
        await speech.stop();
        // Small delay to ensure previous session is fully stopped
        await Future.delayed(const Duration(milliseconds: 200));

        speech.listen(
          onResult: _handleSpeechResult,
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        );
      } catch (e) {
        _handleListeningError(e.toString());
      }
    } catch (e) {
      _handleListeningError('Speech recognition error: $e');
    }
  }

  void _showSpeechUnavailableMessage() {
    Get.snackbar(
      'Speech Recognition Unavailable',
      'Speech recognition is not available in this browser or requires permission.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color.fromRGBO(244, 67, 54, 0.7),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    isListening.value = false;
  }

  void _handleSpeechResult(stt_result.SpeechRecognitionResult result) {
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
  }

  void _handleListeningError(String error) {
    isListening.value = false;
    Get.snackbar(
      'Error',
      'Failed to start listening: $error',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color.fromRGBO(244, 67, 54, 0.7),
      colorText: Colors.white,
    );
  }

  void stopListening() {
    try {
      speech.stop();
    } catch (e) {
      // Ignore errors when stopping
    } finally {
      isListening.value = false;
    }
  }

  void updateChatSize(double width, double height) {
    // Add minimum and maximum constraints
    width = width.clamp(250, 800);
    height = height.clamp(350, 800);

    // Only update if the values have actually changed
    if (width != chatWidth.value) {
      chatWidth.value = width;
    }
    if (height != chatHeight.value) {
      chatHeight.value = height;
    }
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
              child: Material(
                elevation: 0,
                color: Colors.transparent,
                child: _buildResizableChat(controller, context),
              ),
            ),

          // Floating chat button with animation
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildChatButton(controller),
          ),
        ],
      );
    });
  }

  Widget _buildChatButton(GeminiChatbotController controller) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(103, 58, 183, 0.3),
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
    );
  }

  Widget _buildResizableChat(
      GeminiChatbotController controller, BuildContext context) {
    return Obx(() {
      final chatWidth = controller.chatWidth.value;
      final chatHeight = controller.chatHeight.value;

      return Container(
        key: ValueKey('chat-container-${controller.isChatOpen.value}'),
        width: chatWidth,
        height: chatHeight,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            // Main chat container
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.15),
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
                      _buildChatHeader(controller),
                      _buildChatResponseArea(controller),

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

                      _buildInputArea(controller, context),
                    ],
                  ),
                ),
              ),
            ),

            // Resize handles - always keep them on top of the chat container
            _buildResizeHandles(controller),
          ],
        ),
      );
    });
  }

  Widget _buildChatHeader(GeminiChatbotController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          const Expanded(
            child: Text(
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
            icon:
                const Icon(Icons.delete_outline, color: Colors.white, size: 20),
            onPressed: controller.clearChat,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            tooltip: 'Clear chat',
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: controller.toggleChat,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildChatResponseArea(GeminiChatbotController controller) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: controller.messages.isEmpty
            ? _buildEmptyChatState()
            : ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller
                      .messages[controller.messages.length - 1 - index];
                  return MessageBubble(message: message);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyChatState() {
    return Center(
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
    );
  }

  Widget _buildInputArea(
      GeminiChatbotController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: Column(
        children: [
          // Only show permission info on web when not yet available
          if (kIsWeb && !controller.speechAvailable.value)
            _buildPermissionInfo(context),
          Row(
            children: [
              _buildMicButton(controller),
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
                      controller.sendMessage(value);
                    }
                  },
                  enabled: !controller.isLoading.value,
                ),
              ),
              _buildSendButton(controller),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMicButton(GeminiChatbotController controller) {
    return IconButton(
      icon: Icon(
        controller.isListening.value ? Icons.mic : Icons.mic_none,
        color: controller.isListening.value
            ? Colors.red
            : (kIsWeb && !controller.speechAvailable.value)
                ? Colors.grey.shade400
                : Colors.grey,
      ),
      onPressed: controller.startListening,
      tooltip: kIsWeb
          ? 'Click to enable voice input (requires permission)'
          : 'Voice input',
    );
  }

  Widget _buildSendButton(GeminiChatbotController controller) {
    return IconButton(
      icon: const Icon(Icons.send, color: TColors.primary),
      onPressed: controller.isLoading.value
          ? null
          : () {
              final text = controller.inputController.text.trim();
              if (text.isNotEmpty) {
                controller.sendMessage(text);
              }
            },
    );
  }

  Widget _buildResizeHandles(GeminiChatbotController controller) {
    // Define a constant for the resize handle color
    const Color resizeHandleColor = Color.fromRGBO(103, 58, 183, 0.4);
    const Color dragHandleColor = Color.fromRGBO(103, 58, 183, 0.7);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Only build resize handles when the container has a valid size
        if (constraints.maxWidth < 1 || constraints.maxHeight < 1) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            // Diagonal resize handle in the top-left corner (make it larger for easier grabbing)
            Positioned(
              left: 0,
              top: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior
                      .opaque, // Important for reliable hit detection
                  onPanUpdate: (details) {
                    controller.updateChatSize(
                      controller.chatWidth.value - details.delta.dx,
                      controller.chatHeight.value - details.delta.dy,
                    );
                  },
                  child: Container(
                    width: 30, // Larger target area
                    height: 30, // Larger target area
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                      ),
                    ),
                    child: Transform.rotate(
                      angle: 3.14159, // 180 degrees in radians
                      child: const Icon(
                        Icons.drag_handle,
                        color: dragHandleColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Vertical resize handle at the top (make it larger for easier grabbing)
            Positioned(
              left: 50,
              right: 50,
              top: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: GestureDetector(
                  behavior: HitTestBehavior
                      .opaque, // Important for reliable hit detection
                  onPanUpdate: (details) {
                    controller.updateChatSize(
                      controller.chatWidth.value,
                      controller.chatHeight.value - details.delta.dy,
                    );
                  },
                  child: Container(
                    height: 16, // Larger target area
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: resizeHandleColor,
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Horizontal resize handle on the left (make it larger for easier grabbing)
            Positioned(
              left: 0,
              top: 50,
              bottom: 50,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  behavior: HitTestBehavior
                      .opaque, // Important for reliable hit detection
                  onPanUpdate: (details) {
                    controller.updateChatSize(
                      controller.chatWidth.value - details.delta.dx,
                      controller.chatHeight.value,
                    );
                  },
                  child: Container(
                    width: 16, // Larger target area
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Container(
                        width: 4,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: resizeHandleColor,
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickReplies(GeminiChatbotController controller) {
    // Define constants for the quick reply colors
    const Color chipBackgroundColor = Color.fromRGBO(103, 58, 183, 0.1);
    const Color chipBorderColor = Color.fromRGBO(103, 58, 183, 0.3);

    // Fixed list of quick replies - use a const list to avoid rebuilds
    const quickReplies = [
      'How do I apply?',
      'Eligibility criteria?',
      'Tell me about scholarships',
    ];

    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      child: Wrap(
        spacing: 8,
        children: quickReplies.map((reply) {
          return ActionChip(
            avatar:
                Icon(Icons.lightbulb_outline, size: 18, color: TColors.primary),
            label: Text(reply, style: const TextStyle(fontSize: 12)),
            backgroundColor: chipBackgroundColor,
            side: BorderSide(color: chipBorderColor),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            onPressed: () => controller.sendMessage(reply),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPermissionInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Microphone access is required for voice input. Click the mic button and allow permissions when prompted.',
              style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  // Define constants for bubble styling
  static const Color userBubbleColor = Color.fromRGBO(103, 58, 183, 0.1);
  static const Color userBubbleBorderColor = Color.fromRGBO(103, 58, 183, 0.3);

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
          if (!message.isUser) _buildBotAvatar(),
          if (message.isUser) const Spacer(),
          Flexible(
            child: _buildMessageBubble(),
          ),
          if (!message.isUser) const Spacer(),
          if (message.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Container(
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
    );
  }

  Widget _buildUserAvatar() {
    return const CircleAvatar(
      radius: 18,
      backgroundColor: TColors.primary,
      child: Icon(
        Icons.person,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMessageBubble() {
    return Container(
      margin: EdgeInsets.only(
        left: message.isUser ? 0 : 8,
        right: message.isUser ? 8 : 0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: message.isUser ? userBubbleColor : Colors.grey.shade200,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(message.isUser ? 16 : 0),
          bottomRight: Radius.circular(message.isUser ? 0 : 16),
        ),
        border:
            message.isUser ? Border.all(color: userBubbleBorderColor) : null,
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
