import 'package:flutter/material.dart';
import 'package:querify/constants/appcolours.dart';
import '../../widgets/animated_background.dart';
import '../../widgets/glowing_button.dart';
import '../../widgets/custom_textfield.dart';
import 'connect_db_popup.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../../services/api_service.dart';
import '../../services/auth_state.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key? key}) : super(key: key);

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  // UI state
  bool sidebarCollapsed = false; // for wide-screen collapsible
  int selectedChatIndex = 0;

  // Dummy chats data
  final List<Map<String, dynamic>> chats = List.generate(6, (i) {
    return {
      'id': 'chat_$i',
      'title': i == 0 ? 'Welcome' : 'Conversation ${i + 1}',
      'messages': <Map<String, dynamic>>[
        {'from': 'bot', 'text': 'Hello! This is a sample message.'},
        {'from': 'user', 'text': 'Hi! I want to query a DB.'},
      ],
      'createdAt': DateTime.now().subtract(Duration(minutes: i * 5)),
    };
  });

  // Controllers
  final TextEditingController searchController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Simulated DB connect state
  bool dbConnected = false;
  String connectedDbName = '';
  String? connectionId;        // ← add this
  bool isTyping = false;

  @override
  void dispose() {
    searchController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void createNewChat() {
    setState(() {
      final newChat = {
        'id': 'chat_${chats.length}',
        'title': 'Conversation ${chats.length + 1}',
        'messages': <Map<String, dynamic>>[
          {'from': 'bot', 'text': 'New conversation started. Ask anything.'}
        ],
        'createdAt': DateTime.now(),
      };
      chats.insert(0, newChat);
      selectedChatIndex = 0;
    });
  }

void sendMessage() async {
  final text = messageController.text.trim();
  if (text.isEmpty) return;

  // Add user message
  setState(() {
    (chats[selectedChatIndex]['messages'] as List).add({
      'from': 'user',
      'text': text,
      'createdAt': DateTime.now(),
    });
    // Auto-title from first message
    if ((chats[selectedChatIndex]['messages'] as List).length == 2) {
      chats[selectedChatIndex]['title'] = text.length > 30 ? text.substring(0, 30) : text;
    }
    messageController.clear();
    isTyping = true;
  });

  try {
    final res = await ApiService.sendMessage(
      text,
      connectionId: connectionId,
      token: AuthState.instance.token,
    );

    setState(() {
      isTyping = false;
      if (res.type == 'sql') {
        (chats[selectedChatIndex]['messages'] as List).add({
          'from': 'bot',
          'text': res.answer,
          'type': 'sql',
          'createdAt': DateTime.now(),
        });
      } else if (res.type == 'eda') {
        (chats[selectedChatIndex]['messages'] as List).add({
          'from': 'bot',
          'text': res.answer,
          'type': 'eda',
          'steps': res.steps,
          'image': res.image,
          'dataframe': res.dataframe,
          'createdAt': DateTime.now(),
        });
      }
    });
  } on ApiException catch (e) {
    setState(() => isTyping = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  } catch (e) {
    setState(() => isTyping = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to get response. Try again.")),
    );
  }
}
void openConnectDbPopup() async {
  final result = await showDialog<Map<String, dynamic>?>(
    context: context,
    builder: (_) => ConnectDBPopup(),
  );

  if (result != null) {
    setState(() {
      dbConnected = true;
      connectionId = result['connectionId'];
      connectedDbName = result['dbname'] ?? 'remote-db';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connected to $connectedDbName')),
    );
  }
}

Widget _buildDataTable(String? dataframeJson) {
  if (dataframeJson == null) return SizedBox.shrink();
  try {
    final data = jsonDecode(dataframeJson);
    List<Map<String, dynamic>> rows = [];
    if (data is List) {
      rows = List<Map<String, dynamic>>.from(data);
    } else if (data is Map && data.containsKey('data')) {
      rows = List<Map<String, dynamic>>.from(data['data']);
    }
    if (rows.isEmpty) return Text('No data', style: TextStyle(color: Colors.white54));
    final columns = rows.first.keys.toList();
    return DataTable(
      headingTextStyle: TextStyle(color: AppColours.primary, fontWeight: FontWeight.bold),
      dataTextStyle: TextStyle(color: Colors.white70, fontSize: 12),
      columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
      rows: rows.map((row) => DataRow(
        cells: columns.map((c) => DataCell(Text(row[c]?.toString() ?? ''))).toList(),
      )).toList(),
    );
  } catch (e) {
    return Text('Could not parse data', style: TextStyle(color: Colors.white54));
  }
}

  Widget buildSidebar(BuildContext context, bool isDrawerMode) {
    final filtered = chats.where((c) {
      final q = searchController.text.trim().toLowerCase();
      if (q.isEmpty) return true;
      return (c['title'] as String).toLowerCase().contains(q);
    }).toList();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ),
              // collapse toggle (only visible on wide screens)
              if (!isDrawerMode)
                IconButton(
                  tooltip: sidebarCollapsed ? 'Expand' : 'Collapse',
                  onPressed: () => setState(() => sidebarCollapsed = !sidebarCollapsed),
                  icon: Icon(
                    sidebarCollapsed ? Icons.chevron_right : Icons.chevron_left,
                    color: Colors.white70,
                  ),
                ),
            ],
          ),
        ),

        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomTextField(
            controller: searchController,
            label: 'Search chats',
            onChanged: (_) => setState(() {}),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.white70),
              onPressed: () {
                searchController.clear();
                setState(() {});
              },
            ),
          ),
        ),
        SizedBox(height: 12),

        // New chat button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GlowingButton(
            text: 'New Chat',
            onTap: () {
              createNewChat();
              if (isDrawerMode) Navigator.pop(context); // close drawer on mobile
            },
          ),
        ),
        SizedBox(height: 12),

        // Connect DB + status
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: openConnectDbPopup,
                  icon: Icon(Icons.storage),
                  label: Text(dbConnected ? 'Connected' : 'Connect DB', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dbConnected ? Colors.green[700] : AppColours.primary,
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10),
        if (dbConnected)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'DB: $connectedDbName',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        SizedBox(height: 14),

        // Divider + list header
        Divider(color: Colors.white12),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final chat = filtered[i];
              final globalIndex = chats.indexOf(chat);
              final isSelected = globalIndex == selectedChatIndex;
              return ListTile(
                dense: true,
                selected: isSelected,
                selectedTileColor: Colors.white10,
                title: Text(
                  chat['title'],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  (chat['messages'] as List).isNotEmpty
                      ? (chat['messages'] as List).last['text']
                      : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                onTap: () {
                  setState(() {
                    selectedChatIndex = globalIndex;
                  });
                  if (isDrawerMode) Navigator.pop(context); // close on mobile
                },
                trailing: PopupMenuButton<String>(
                  color: AppColours.secondary,
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'rename', child: Text('Rename')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      setState(() {
                        final removed = chats.removeAt(globalIndex);
                        if (selectedChatIndex >= chats.length) selectedChatIndex = chats.length - 1;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${removed['title']} deleted')),
                        );
                      });
                    } else if (value == 'rename') {
                      // quick rename dialog
                      showDialog(
                        context: context,
                        builder: (_) {
                          final ctrl = TextEditingController(text: chat['title']);
                          return AlertDialog(
                            backgroundColor: AppColours.secondary,
                            title: Text('Rename chat'),
                            content: TextField(controller: ctrl),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  setState(() => chat['title'] = ctrl.text);
                                  Navigator.pop(context);
                                },
                                child: Text('Rename'),
                              )
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),

        // Logout button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            icon: Icon(Icons.logout, color: Colors.white70),
            label: Text('Logout', style: TextStyle(color: Colors.white70)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white12),
            ),
          ),
        ),
      ],
    );

    // For drawer mode we return the content directly (so it is used as drawer child)
    if (isDrawerMode) {
      return SafeArea(child: content);
    }

    // For wide screens return a decorated container
    final width = sidebarCollapsed ? 80.0 : 320.0;
    return Container(
      width: width,
      padding: EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x11000000), Color.fromARGB(0, 32, 32, 32)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(right: BorderSide(color: Colors.white10)),
      ),
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final messages = chats[selectedChatIndex]['messages'] as List;

    return Scaffold(
      // For small screens we use a drawer for the sidebar
      drawer: isWide ? null : Drawer(child: buildSidebar(context, true)),
      body: AnimatedBackground(
        child: SafeArea(
          child: Row(
            children: [
              if (isWide) buildSidebar(context, false),

              // Main chat area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Card(
                    color: AppColours.secondary.withOpacity(0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppColours.primary.withOpacity(0.25)),
                    ),
                    elevation: 6,
                    child: Column(
                      children: [
                        // Top bar
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Row(
                            children: [
                              // Mobile menu button (when narrow)
                              if (!isWide)
                                IconButton(
                                  icon: Icon(Icons.menu, color: Colors.white70),
                                  onPressed: () => Scaffold.of(context).openDrawer(),
                                ),

                              // Chat title
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chats[selectedChatIndex]['title'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      dbConnected ? 'Connected: $connectedDbName' : 'No DB connected',
                                      style: TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),

                              // New Chat quick action
                              GlowingButton(
                                text: 'New Chat',
                                onTap: createNewChat,
                              ),
                              SizedBox(width: 12),

                              // Connect DB quick action
                              OutlinedButton.icon(
                                onPressed: openConnectDbPopup,
                                icon: Icon(Icons.storage, color: Colors.white70),
                                label: Text('Connect DB', style: TextStyle(color: Colors.white70)),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.white12),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(color: Colors.white12, height: 1),

                        // Messages list
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListView.builder(
                                      reverse: false,
                                      itemCount: messages.length,
                                      itemBuilder: (_, i) {
                                        final msg = messages[i] as Map<String, dynamic>;
                                        final fromUser = (msg['from'] == 'user');
                                        return Align(
                                          alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(vertical: 6),
                                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                                            decoration: BoxDecoration(
                                              color: fromUser ? Color.fromARGB(255, 91, 91, 91) : Color.fromARGB(255, 46, 46, 46),
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                  Text(
                                    msg['text'] ?? '',
                                    style: TextStyle(color: Colors.white.withOpacity(0.95)),
                                  ),
                              
                                  // EDA: steps
                                  if (msg['type'] == 'eda' && msg['steps'] != null) ...[
                                    SizedBox(height: 8),
                                    ExpansionTile(
                                      title: Text('Steps', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                      children: (msg['steps'] as List)
                                          .map((s) => ListTile(
                                                dense: true,
                                                title: Text(s.toString(),
                                                    style: TextStyle(color: Colors.white60, fontSize: 12)),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                              
                                  // EDA: dataframe
                                  if (msg['type'] == 'eda' && msg['dataframe'] != null) ...[
                                    SizedBox(height: 8),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: _buildDataTable(msg['dataframe']),
                                    ),
                                  ],
                              
                                  // EDA: image
                                  if (msg['type'] == 'eda' && msg['image'] != null) ...[
                                    SizedBox(height: 8),
                                    if (msg['image'] != null && (msg['image'] as String).isNotEmpty)
                                      Image.memory(base64Decode(msg['image'] as String)),
                                  ],
                              
                                  SizedBox(height: 6),
                                  Text(
                                    msg['createdAt'] != null
                                        ? (msg['createdAt'] as DateTime).toLocal().toString().split('.')[0]
                                        : '',
                                    style: TextStyle(color: Colors.white38, fontSize: 10),
                                  ),
                                ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              if (isTyping)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 16, height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColours.primary,
                ),
              ),
              SizedBox(width: 10),
              Text('Thinking...', style: TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
        ),
                            ],
                          ),
                        ),

                        // Input area
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: messageController,
                                  label: 'Type your query or message...',
                                  onSubmitted: (_) => sendMessage(),
                                ),
                              ),
                              SizedBox(width: 12),
                              GlowingButton(
                                text: 'Send',
                                onTap: sendMessage,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
