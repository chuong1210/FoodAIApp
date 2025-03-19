import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import 'dart:math';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Add initial greeting message
    _addBotMessage(
        'Xin chào! Tôi là NutriBot, trợ lý dinh dưỡng của bạn. Tôi có thể giúp gì cho bạn hôm nay?');
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
      ));
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate bot thinking
    Future.delayed(const Duration(milliseconds: 500), () {
      _getBotResponse(text);
    });
  }

  void _getBotResponse(String userMessage) {
    // Simulate AI response with predefined nutrition advice
    final response = _generateNutritionResponse(userMessage);

    setState(() {
      _isTyping = false;
      _addBotMessage(response);
    });

    _scrollToBottom();
  }

  void _addBotMessage(String message) {
    _messages.add(ChatMessage(
      text: message,
      isUser: false,
    ));
  }

  void _scrollToBottom() {
    // Scroll to bottom of chat after a short delay to ensure the list is updated
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateNutritionResponse(String userMessage) {
    // Convert to lowercase for easier matching
    final message = userMessage.toLowerCase();

    // Check for common nutrition questions and provide responses
    if (message.contains('calo') || message.contains('calorie')) {
      return 'Lượng calo hàng ngày phụ thuộc vào nhiều yếu tố như tuổi, giới tính, cân nặng và mức độ hoạt động. Trung bình, nam giới cần khoảng 2500 calo và nữ giới cần khoảng 2000 calo mỗi ngày.';
    } else if (message.contains('protein') || message.contains('đạm')) {
      return 'Protein rất quan trọng cho việc xây dựng cơ bắp và sửa chữa mô. Nguồn protein tốt bao gồm thịt nạc, cá, trứng, đậu và các sản phẩm từ sữa. Bạn nên tiêu thụ khoảng 0.8g protein cho mỗi kg trọng lượng cơ thể.';
    } else if (message.contains('carb') || message.contains('tinh bột')) {
      return 'Carbohydrate là nguồn năng lượng chính cho cơ thể. Nên ưu tiên carb phức hợp như ngũ cốc nguyên hạt, rau củ và trái cây thay vì carb đơn giản như đường và bánh kẹo.';
    } else if (message.contains('chất béo') || message.contains('fat')) {
      return 'Chất béo lành mạnh rất cần thiết cho sức khỏe. Hãy chọn các nguồn chất béo không bão hòa như dầu ô liu, bơ, các loại hạt và cá béo. Hạn chế chất béo bão hòa và chất béo trans.';
    } else if (message.contains('giảm cân') || message.contains('giảm cân')) {
      return 'Để giảm cân lành mạnh, hãy tạo thâm hụt calo nhẹ (khoảng 500 calo/ngày), kết hợp với tập thể dục đều đặn và ăn nhiều thực phẩm giàu dinh dưỡng. Nên giảm 0.5-1kg mỗi tuần là an toàn và bền vững.';
    } else if (message.contains('tăng cân') || message.contains('tăng cân')) {
      return 'Để tăng cân lành mạnh, hãy tăng lượng calo tiêu thụ và tập trung vào thực phẩm giàu dinh dưỡng. Kết hợp với tập luyện sức mạnh để xây dựng cơ bắp thay vì chỉ tăng mỡ.';
    } else if (message.contains('nước') || message.contains('uống')) {
      return 'Uống đủ nước rất quan trọng cho sức khỏe tổng thể. Mỗi ngày bạn nên uống khoảng 2-3 lít nước, tùy thuộc vào mức độ hoạt động và điều kiện thời tiết.';
    } else if (message.contains('vitamin') || message.contains('khoáng chất')) {
      return 'Vitamin và khoáng chất là các vi chất dinh dưỡng cần thiết cho nhiều chức năng cơ thể. Ăn đa dạng các loại thực phẩm, đặc biệt là rau củ quả nhiều màu sắc, sẽ giúp bạn nhận đủ các vi chất này.';
    } else if (message.contains('ăn chay') || message.contains('vegetarian')) {
      return 'Chế độ ăn chay có thể rất lành mạnh nếu được lên kế hoạch tốt. Hãy đảm bảo bạn nhận đủ protein từ đậu, đậu lăng, đậu phụ và các sản phẩm từ sữa (nếu bạn ăn lacto-vegetarian). Bổ sung vitamin B12 có thể cần thiết.';
    } else if (message.contains('bữa ăn') || message.contains('meal')) {
      return 'Nên ăn 3 bữa chính và 1-2 bữa nhẹ mỗi ngày. Mỗi bữa ăn nên cân bằng với protein, carb phức hợp, chất béo lành mạnh và nhiều rau củ.';
    } else if (message.contains('xin chào') ||
        message.contains('hi') ||
        message.contains('hello')) {
      return 'Xin chào! Tôi là NutriBot, trợ lý dinh dưỡng của bạn. Bạn có câu hỏi gì về dinh dưỡng không?';
    } else if (message.contains('cảm ơn') || message.contains('thank')) {
      return 'Không có gì! Rất vui được giúp đỡ bạn. Bạn có câu hỏi nào khác không?';
    } else {
      // Random general nutrition tips for other queries
      final tips = [
        'Ăn nhiều rau củ quả đa dạng màu sắc để nhận đủ vitamin và khoáng chất.',
        'Uống đủ nước mỗi ngày, ít nhất 2 lít.',
        'Hạn chế thực phẩm chế biến sẵn và đồ ăn nhanh.',
        'Ăn chậm và nhai kỹ giúp tiêu hóa tốt hơn và kiểm soát cân nặng.',
        'Protein rất quan trọng cho việc xây dựng và duy trì cơ bắp.',
        'Chất béo lành mạnh như trong cá, quả bơ và các loại hạt rất cần thiết cho sức khỏe.',
        'Ưu tiên carbohydrate phức hợp như ngũ cốc nguyên hạt thay vì đường đơn giản.',
        'Ăn đủ chất xơ giúp hệ tiêu hóa khỏe mạnh.',
        'Kết hợp chế độ ăn uống lành mạnh với tập thể dục đều đặn.',
        'Hạn chế muối và đường trong chế độ ăn hàng ngày.',
      ];

      return tips[Random().nextInt(tips.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tư vấn dinh dưỡng'),
        backgroundColor: const Color(0xFF1A73E8),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                image: DecorationImage(
                  image: const NetworkImage(
                    'https://images.unsplash.com/photo-1498837167922-ddd27525d352?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.9),
                    BlendMode.lighten,
                  ),
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length,
                itemBuilder: (_, int index) {
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
          ),
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF1A73E8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'NutriBot đang nhập...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF1A73E8) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (message.isUser)
            const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: const Color(0xFF1A73E8),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: const Icon(
          Icons.health_and_safety,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined),
              color: Colors.grey[600],
              onPressed: () {
                // Emoji picker functionality could be added here
              },
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Nhập câu hỏi về dinh dưỡng...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
                onSubmitted: _handleSubmitted,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              color: const Color(0xFF1A73E8),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}
