import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgentWorkerChatPage extends StatefulWidget {
  final String agentId;
  final String workerId;
  final String workerName;
  final String jobId;

  const AgentWorkerChatPage({
    super.key,
    required this.agentId,
    required this.workerId,
    required this.workerName,
    required this.jobId,
  });

  @override
  State<AgentWorkerChatPage> createState() => _AgentWorkerChatPageState();
}

class _AgentWorkerChatPageState extends State<AgentWorkerChatPage> {
  final TextEditingController _controller = TextEditingController();

  Stream<QuerySnapshot> get _messagesStream {
    return FirebaseFirestore.instance
        .collection('agent_worker_chats')
        .doc(widget.jobId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('agent_worker_chats')
        .doc(widget.jobId)
        .collection('messages')
        .add({
          'senderId': widget.agentId,
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
        });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.workerName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == widget.agentId;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(msg['text']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
