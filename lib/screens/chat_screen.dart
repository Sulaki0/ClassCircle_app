import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isNewUser;

  const ChatScreen({
    super.key,
    required this.onThemeChanged,
    this.isNewUser = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Chat data - empty for new users
  late final List<Map<String, dynamic>> _chats;

  @override
  void initState() {
    super.initState();
    // New users start with empty chats
    if (widget.isNewUser) {
      _chats = [];
    } else {
      _chats = [
        {
          'name': 'Sarah Johnson',
          'message': 'See you in class tomorrow!',
          'time': '10:30 AM',
          'unread': 2,
          'isGroup': false,
          'avatar': 'S',
          'image': 'assets/images/sarah.png',
          'online': true,
          'messages': [
            {'text': 'Hey! How are you?', 'isMe': false, 'time': '10:15 AM'},
            {'text': 'I\'m good! Ready for the exam?', 'isMe': true, 'time': '10:20 AM'},
            {'text': 'See you in class tomorrow!', 'isMe': false, 'time': '10:30 AM'},
          ],
        },
        {
          'name': 'Mike Chen',
          'message': 'Can you share the notes from today?',
          'time': '9:15 AM',
          'unread': 0,
          'isGroup': false,
          'avatar': 'M',
          'image': 'assets/images/mike.png',
          'online': true,
          'messages': [
            {'text': 'Hi Mike!', 'isMe': false, 'time': '9:00 AM'},
            {'text': 'Hey! Can you share the notes from today?', 'isMe': false, 'time': '9:15 AM'},
          ],
        },
        {
          'name': 'ICT725 Study Group',
          'message': 'Sarah: Assignment due next week!',
          'time': 'Yesterday',
          'unread': 5,
          'isGroup': true,
          'avatar': 'G',
          'image': null,
          'online': false,
          'members': 12,
          'messages': [
            {'text': 'Hey everyone!', 'isMe': false, 'time': 'Yesterday 2:00 PM'},
            {'text': 'Assignment due next week!', 'isMe': false, 'time': 'Yesterday 2:30 PM'},
            {'text': 'I\'m working on it now', 'isMe': true, 'time': 'Yesterday 3:00 PM'},
          ],
        },
        {
          'name': 'PHY301 Lab Group',
          'message': 'Mike: Lab report due Friday',
          'time': 'Yesterday',
          'unread': 1,
          'isGroup': true,
          'avatar': 'P',
          'image': null,
          'online': false,
          'members': 5,
          'messages': [
            {'text': 'Lab report due Friday', 'isMe': false, 'time': 'Yesterday 1:00 PM'},
            {'text': 'Has anyone started?', 'isMe': true, 'time': 'Yesterday 1:30 PM'},
          ],
        },
        {
          'name': 'Emma Wilson',
          'message': 'Thanks for the help!',
          'time': '2 days ago',
          'unread': 0,
          'isGroup': false,
          'avatar': 'E',
          'image': 'assets/images/emma.png',
          'online': false,
          'messages': [
            {'text': 'Can you help me with this?', 'isMe': false, 'time': '2 days ago'},
            {'text': 'Sure! Let me help you out', 'isMe': true, 'time': '2 days ago'},
            {'text': 'Thanks for the help!', 'isMe': false, 'time': '2 days ago'},
          ],
        },
        {
          'name': 'ICT701 Project Team',
          'message': 'Meeting at 3 PM today',
          'time': '2 days ago',
          'unread': 0,
          'isGroup': true,
          'avatar': 'I',
          'image': null,
          'online': false,
          'members': 8,
          'messages': [
            {'text': 'Meeting at 3 PM today', 'isMe': false, 'time': '2 days ago'},
          ],
        },
      ];
    }
  }

  // Track current chat for messaging
  Map<String, dynamic>? _currentChat;
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  // Reusable avatar widget - shows image if available, otherwise letter
  Widget _buildAvatar({
    required Map<String, dynamic> chat,
    double radius = 28,
    double fontSize = 14,
  }) {
    final bool hasImage = chat['image'] != null && (chat['image'] as String).isNotEmpty;

    if (hasImage) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.2),
        child: ClipOval(
          child: Image.asset(
            chat['image'],
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  chat['avatar'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: chat['isGroup']
                        ? const Color(0xFF6C63FF)
                        : Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: chat['isGroup']
          ? const Color(0xFF6C63FF).withValues(alpha: 0.3)
          : const Color(0xFF6C63FF),
      child: Text(
        chat['avatar'],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: chat['isGroup'] ? const Color(0xFF6C63FF) : Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.create,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              _showCreateGroupDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All', 'All'),
                const SizedBox(width: 8),
                _buildFilterChip('Unread', 'Unread'),
                const SizedBox(width: 8),
                _buildFilterChip('Groups', 'Groups'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _chats.isEmpty
                ? _buildEmptyState(isDarkMode)
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];

                if (_selectedFilter == 'Unread' && chat['unread'] == 0) {
                  return const SizedBox.shrink();
                }
                if (_selectedFilter == 'Groups' && !chat['isGroup']) {
                  return const SizedBox.shrink();
                }

                return _buildChatTile(chat);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Empty state widget for new users
  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Messages Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation by creating a group chat\nor finding classmates to chat with!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _showCreateGroupDialog,
                icon: const Icon(Icons.group_add),
                label: const Text('Create Group Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _showFindClassmatesDialog,
                icon: const Icon(Icons.search),
                label: const Text('Find Classmates'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6C63FF),
                  side: const BorderSide(color: Color(0xFF6C63FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = _selectedFilter == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF6C63FF)
                : (isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDarkMode ? Colors.grey : Colors.grey[700]),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatTile(Map<String, dynamic> chat) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: chat['unread'] > 0
          ? (isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0))
          : (isDarkMode ? const Color(0xFF0A0A0A) : Colors.white),
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isDarkMode ? 0 : 1,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Stack(
          children: [
            _buildAvatar(chat: chat, radius: 28),
            if (chat['online'])
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                chat['name'],
                style: TextStyle(
                  fontWeight: chat['unread'] > 0 ? FontWeight.bold : FontWeight.normal,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Text(
              chat['time'],
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.grey : Colors.grey[600],
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                chat['message'],
                style: TextStyle(
                  color: chat['unread'] > 0
                      ? (isDarkMode ? Colors.white : Colors.black)
                      : (isDarkMode ? Colors.grey : Colors.grey[600]),
                  fontWeight: chat['unread'] > 0 ? FontWeight.w500 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (chat['unread'] > 0)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF6C63FF),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${chat['unread']}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          _openChat(chat);
        },
      ),
    );
  }

  void _showSearchDialog() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          title: Text(
            'Search Chats',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Search by name...',
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[600],
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDarkMode ? Colors.grey : Colors.grey[600],
              ),
              filled: true,
              fillColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey : Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (_searchController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Searching for: ${_searchController.text}'),
                      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.grey[800],
                    ),
                  );
                }
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  // Find Classmates dialog for new users
  void _showFindClassmatesDialog() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Sample classmates to discover
    final List<Map<String, String?>> classmates = [
      {'name': 'Sarah Johnson', 'course': 'ICT725', 'image': 'assets/images/sarah.png'},
      {'name': 'Mike Chen', 'course': 'ICT701', 'image': 'assets/images/mike.png'},
      {'name': 'Emma Wilson', 'course': 'ENG101', 'image': 'assets/images/emma.png'},
      {'name': 'James Brown', 'course': 'MATH201', 'image': null},
      {'name': 'Priya Sharma', 'course': 'PHY301', 'image': null},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.people, color: Color(0xFF6C63FF)),
                          const SizedBox(width: 8),
                          Text(
                            'Find Classmates',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap a classmate to start a conversation',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode ? Colors.grey : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: classmates.length,
                    itemBuilder: (context, index) {
                      final person = classmates[index];
                      final hasImage = person['image'] != null;

                      return Card(
                        color: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF6C63FF),
                            backgroundImage: hasImage
                                ? AssetImage(person['image']!)
                                : null,
                            child: !hasImage
                                ? Text(
                              person['name']![0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : null,
                          ),
                          title: Text(
                            person['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            person['course']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey : Colors.grey[600],
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chat_bubble_outline,
                            color: Color(0xFF6C63FF),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _startChatWith(
                              person['name']!,
                              person['course']!,
                              person['image'],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Start a new chat with someone (with optional image)
  void _startChatWith(String name, String course, String? image) {
    setState(() {
      _chats.insert(0, {
        'name': name,
        'message': 'Say hi to start the conversation!',
        'time': 'Just now',
        'unread': 0,
        'isGroup': false,
        'avatar': name[0],
        'image': image,
        'online': true,
        'messages': [
          {'text': 'Hi! I\'m from $course. Nice to meet you!', 'isMe': false, 'time': 'Just now'},
        ],
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chat with $name created!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          title: Text(
            'Create Group Chat',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey : Colors.grey[600],
                  ),
                  prefixIcon: Icon(
                    Icons.group,
                    color: isDarkMode ? Colors.grey : Colors.grey[600],
                  ),
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: codeController,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey : Colors.grey[600],
                  ),
                  prefixIcon: Icon(
                    Icons.description,
                    color: isDarkMode ? Colors.grey : Colors.grey[600],
                  ),
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey : Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _chats.insert(0, {
                      'name': nameController.text,
                      'message': 'Group created! Start chatting!',
                      'time': 'Just now',
                      'unread': 0,
                      'isGroup': true,
                      'avatar': nameController.text.substring(0, 1).toUpperCase(),
                      'image': null,
                      'online': false,
                      'members': 1,
                      'messages': [
                        {'text': 'Welcome to ${nameController.text}!', 'isMe': false, 'time': 'Just now'},
                      ],
                    });
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Group created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _openChat(Map<String, dynamic> chat) {
    setState(() {
      _currentChat = chat;
      chat['unread'] = 0;
      _isTyping = false;
    });

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          _buildAvatar(chat: chat, radius: 20, fontSize: 12),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                Text(
                                  chat['isGroup']
                                      ? 'Group Chat - ${chat['members'] ?? 0} members'
                                      : 'Online',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode ? Colors.grey : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: chat['messages'].length + (_isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_isTyping && index == chat['messages'].length) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildAvatar(chat: chat, radius: 16, fontSize: 10),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                        bottomLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: isDarkMode ? Colors.grey : Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'typing...',
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.grey : Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final message = chat['messages'][index];
                          final isMe = message['isMe'] ?? false;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isMe)
                                  _buildAvatar(chat: chat, radius: 16, fontSize: 10),
                                if (!isMe) const SizedBox(width: 8),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isMe
                                              ? const Color(0xFF6C63FF)
                                              : (isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0)),
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(16),
                                            topRight: const Radius.circular(16),
                                            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                                            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                                          ),
                                        ),
                                        child: Text(
                                          message['text'],
                                          style: TextStyle(
                                            color: isMe ? Colors.white : (isDarkMode ? Colors.white : Colors.black),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          message['time'] ?? '',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: isDarkMode ? Colors.grey : Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isMe) const SizedBox(width: 8),
                                if (isMe)
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: const Color(0xFF6C63FF),
                                    child: const Text(
                                      'Me',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[100],
                        border: Border(
                          top: BorderSide(color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.attach_file,
                              color: isDarkMode ? Colors.grey : Colors.grey[600],
                            ),
                            onPressed: () {},
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: TextField(
                                controller: _messageController,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: TextStyle(
                                    color: isDarkMode ? Colors.grey : Colors.grey[600],
                                  ),
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (value) {
                                  _sendMessage(chat, setModalState);
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Color(0xFF6C63FF),
                            ),
                            onPressed: () {
                              _sendMessage(chat, setModalState);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  void _sendMessage(Map<String, dynamic> chat, StateSetter setModalState) {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    final now = DateTime.now();
    final timeString = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    setModalState(() {
      chat['messages'].add({
        'text': messageText,
        'isMe': true,
        'time': timeString,
      });

      chat['message'] = messageText;
      chat['time'] = 'Just now';
    });

    _messageController.clear();

    _simulateReply(chat, setModalState);
  }

  void _simulateReply(Map<String, dynamic> chat, StateSetter setModalState) {
    final userMessages = chat['messages']
        .where((m) => m['isMe'] == true)
        .toList();

    if (userMessages.isEmpty) return;

    final lastUserMessage = userMessages.last['text'].toString().toLowerCase();
    final reply = _getSmartReply(lastUserMessage);

    setModalState(() => _isTyping = true);

    final delay = Duration(milliseconds: 800 + (reply.length * 30));
    final now = DateTime.now();
    final timeString = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    Future.delayed(delay, () {
      if (!mounted) return;

      setModalState(() {
        _isTyping = false;
        chat['messages'].add({
          'text': reply,
          'isMe': false,
          'time': timeString,
        });
        chat['message'] = reply;
        chat['time'] = 'Just now';
      });
    });
  }

  String _getSmartReply(String message) {
    if (RegExp(r'\b(hi|hey|hello|yo)\b').hasMatch(message)) {
      return 'Hey! How are you doing?';
    }

    if (message.contains('thank')) {
      return 'You\'re welcome!';
    }

    if (message.contains('bye') || message.contains('see you')) {
      return 'See you later!';
    }

    if (message.contains('notes') || message.contains('note')) {
      return 'Sure! I\'ll send them over';
    }
    if (message.contains('assignment') || message.contains('homework')) {
      return 'When is it due again?';
    }
    if (message.contains('exam') || message.contains('test')) {
      return 'I\'m studying for it too!';
    }
    if (message.contains('project')) {
      return 'Let\'s meet up to discuss it!';
    }
    if (message.contains('study')) {
      return 'Want to study together?';
    }
    if (message.contains('class') || message.contains('lecture')) {
      return 'That class was interesting today!';
    }
    if (message.contains('meeting')) {
      return 'What time is the meeting?';
    }

    if (message.contains('when')) return 'Let me check and get back to you!';
    if (message.contains('where')) return 'I think it\'s in the usual place?';
    if (message.contains('how')) return 'It\'s not too hard once you start!';
    if (message.contains('why')) return 'Good question! Let me think';
    if (message.contains('who')) return 'I\'m not sure, let me ask around!';

    if (RegExp(r'\b(yes|yeah|yep|sure|ok|okay)\b').hasMatch(message)) {
      return 'Great! Let\'s do it';
    }
    if (RegExp(r'\b(no|nope|nah)\b').hasMatch(message)) {
      return 'No worries! Maybe next time';
    }

    if (message.contains('?')) {
      return 'Good question! Let me think about it';
    }

    final fallbacks = [
      'That sounds interesting!',
      'Tell me more',
      'I see what you mean!',
      'Good point!',
      'Haha, yeah!',
      'For sure!',
    ];
    return fallbacks[DateTime.now().millisecondsSinceEpoch % fallbacks.length];
  }
}