// chatbot.dart
import 'package:flutter/material.dart';
import '../services/aiservice.dart';


class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final AIService _aiService = AIService();
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAI();
  }

  void _initializeAI() async {
    _addBotMessage("connect to AI");

    try {
      await _aiService.sendMessage("hello");
      setState(() {
        _isInitialized = true;
      });
      _addBotMessage("Connect Done！");
      _addBotMessage("Hallo");
    } catch (e) {
      _addBotMessage("Failed Connected");
    }
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: false));
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });
  }

  void _sendMessage() async {
    String text = _textController.text.trim();
    if (text.isEmpty || _isLoading || !_isInitialized) return;

    _addUserMessage(text);
    _textController.clear();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _aiService.sendMessage(text);
      _addBotMessage(response);
    } catch (e) {
      _addBotMessage("unfailed: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _retryInitialize() {
    setState(() {
      _messages.clear();
      _isInitialized = false;
    });
    _initializeAI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
        actions: [
          if (!_isInitialized)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _retryInitialize,
              tooltip: 'retry Initialize',
            ),
        ],
      ),
      body: Column(
        children: [
          if (_isInitialized)
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.green[50],
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'AI preparing done',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 12,
                    child: Icon(Icons.smart_toy, color: Colors.white, size: 12),
                  ),
                  SizedBox(width: 8),
                  Text('loading....'),
                ],
              ),
            ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 16,
              child: Icon(Icons.smart_toy, color: Colors.white, size: 16),
            ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.blue[50] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(message.text),
                ),
              ],
            ),
          ),
          if (message.isUser)
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 16,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: _isInitialized ? 'Enter message...' : 'Initialize...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_isInitialized && !_isLoading) ? (_) => _sendMessage() : null,
              enabled: _isInitialized && !_isLoading,
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: (_isInitialized && !_isLoading) ? _sendMessage : null,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}