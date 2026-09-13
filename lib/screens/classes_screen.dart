import 'package:flutter/material.dart';

class ClassesScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isNewUser;

  const ClassesScreen({
    super.key,
    required this.onThemeChanged,
    this.isNewUser = false,
  });

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  late final List<Map<String, dynamic>> _studyGroups;

  String _selectedUnit = 'All';
  String _selectedMode = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    final bool joinedByDefault = !widget.isNewUser;

    _studyGroups = [
      {
        'name': 'ICT725 Study Cohort',
        'code': 'ICT725',
        'members': 8,
        'mode': 'Face-to-Face',
        'activity': 95,
        'description': 'Weekly UX design discussions and project collaboration',
        'schedule': 'Wed 6:00 PM',
        'location': 'Library Room',
        'joined': joinedByDefault,
        'isCreated': false,
      },
      {
        'name': 'ICT201 Data Structures Team',
        'code': 'ICT201',
        'members': 5,
        'mode': 'Online',
        'activity': 88,
        'description': 'Weekly data structures problem solving',
        'schedule': 'Fri 4:00 PM',
        'location': 'Zoom',
        'joined': joinedByDefault,
        'isCreated': false,
      },
      {
        'name': 'ICT202 Algorithms Weekly',
        'code': 'ICT202',
        'members': 12,
        'mode': 'Online',
        'activity': 51,
        'description': 'Algorithm practice and discussion',
        'schedule': 'Tue 7:00 PM',
        'location': 'Engineering Building',
        'joined': false,
        'isCreated': false,
      },
      {
        'name': 'ICT701 Database Study Group',
        'code': 'ICT701',
        'members': 12,
        'mode': 'Online',
        'activity': 50,
        'description': 'Database design and SQL practice',
        'schedule': 'Tue 7:00 PM',
        'location': 'Google Meet',
        'joined': joinedByDefault,
        'isCreated': false,
      },
      {
        'name': 'PHY301 Lab Partners',
        'code': 'PHY301',
        'members': 6,
        'mode': 'Face-to-Face',
        'activity': 72,
        'description': 'Physics lab experiment collaboration',
        'schedule': 'Thu 2:00 PM',
        'location': 'Science Building 204',
        'joined': false,
        'isCreated': false,
      },
      {
        'name': 'MATH201 Problem Solvers',
        'code': 'MATH201',
        'members': 4,
        'mode': 'Online',
        'activity': 60,
        'description': 'Math problem sets and exam prep',
        'schedule': 'Mon 5:00 PM',
        'location': 'Zoom',
        'joined': false,
        'isCreated': false,
      },
    ];
  }

  List<String> get _unitOptions {
    final codes = <String>{'All'};
    for (final g in _studyGroups) {
      codes.add(g['code'] as String);
    }
    return codes.toList();
  }

  List<Map<String, dynamic>> get _filteredGroups {
    var filtered = _studyGroups;

    if (_selectedUnit != 'All') {
      filtered = filtered.where((g) => g['code'] == _selectedUnit).toList();
    }

    if (_selectedMode != 'All') {
      filtered = filtered.where((g) => g['mode'] == _selectedMode).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((g) => g['name']
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Groups'),
        backgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateGroupDialog,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Create',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // ---- Fixed filter header ----
          Container(
            color: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: TextField(
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search study groups...',
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.grey[600],
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDarkMode ? Colors.grey : Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: isDarkMode
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFFF0F0F0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // Unit label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'UNIT FILTER',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: isDarkMode ? Colors.grey : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Unit chips
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _unitOptions.length,
                    itemBuilder: (context, index) {
                      final unit = _unitOptions[index];
                      final selected = _selectedUnit == unit;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedUnit = unit),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF6C63FF)
                                  : (isDarkMode
                                  ? const Color(0xFF1A1A1A)
                                  : const Color(0xFFF0F0F0)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                unit,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : (isDarkMode
                                      ? Colors.grey
                                      : Colors.grey[700]),
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Mode chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildModeChip('All', 'All', isDarkMode),
                      const SizedBox(width: 8),
                      _buildModeChip('Face-to-Face', 'Face-to-Face', isDarkMode),
                      const SizedBox(width: 8),
                      _buildModeChip('Online', 'Online', isDarkMode),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---- Scrollable group list ----
          Expanded(
            child: _filteredGroups.isEmpty
                ? _buildEmptyState(isDarkMode)
                : ListView.builder(
              key: const PageStorageKey('classes_list'),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: _filteredGroups.length,
              itemBuilder: (context, index) {
                return _buildGroupCard(_filteredGroups[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeChip(String label, String value, bool isDarkMode) {
    final isSelected = _selectedMode == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMode = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : (isDarkMode ? Colors.grey : Colors.grey[600]),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
                Icons.group_add,
                size: 64,
                color: Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Study Groups Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different filter or create a new group.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isJoined = group['joined'] == true || group['isCreated'] == true;
    final bool isCreated = group['isCreated'] == true;

    return Card(
      color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Name + Activity =====
            Row(
              children: [
                Expanded(
                  child: Text(
                    group['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${group['activity']}% Active',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ===== Code + Mode badge =====
            Row(
              children: [
                Text(
                  group['code'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        group['mode'] == 'Online'
                            ? Icons.videocam
                            : Icons.location_on,
                        size: 10,
                        color: const Color(0xFF6C63FF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        group['mode'],
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCreated) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Created',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // ===== Members + schedule + location =====
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _buildInfoChip(
                  Icons.people,
                  '${group['members']} members',
                  isDarkMode,
                ),
                _buildInfoChip(
                  Icons.access_time,
                  group['schedule'],
                  isDarkMode,
                ),
                _buildInfoChip(
                  Icons.location_on,
                  group['location'],
                  isDarkMode,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ===== Avatars row (left) + Action (right) — separated =====
            Row(
              children: [
                // Avatars
                SizedBox(
                  width: 100,
                  height: 30,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        child: _buildMiniAvatarCircle('JD', Colors.blue),
                      ),
                      Positioned(
                        left: 20,
                        child: _buildMiniAvatarCircle('SK', Colors.teal),
                      ),
                      Positioned(
                        left: 40,
                        child: _buildMiniAvatarCircle('AM', Colors.pink),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Action area — takes remaining space, aligned right
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: isJoined
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isCreated) ...[
                          TextButton(
                            onPressed: () => _leaveGroup(group),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              minimumSize: const Size(0, 36),
                              tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.exit_to_app, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Leave',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        // ⬇️ NEW: Menu button for creator (only when isCreated)
                        if (isCreated)
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              size: 20,
                              color: isDarkMode
                                  ? Colors.grey
                                  : Colors.grey[600],
                            ),
                            color: isDarkMode
                                ? const Color(0xFF2A2A2A)
                                : Colors.white,
                            onSelected: (value) {
                              if (value == 'changeMode') {
                                _showChangeModeDialog(group);
                              } else if (value == 'delete') {
                                _deleteGroup(group);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'changeMode',
                                child: Row(
                                  children: [
                                    Icon(
                                      group['mode'] == 'Online'
                                          ? Icons.location_on
                                          : Icons.videocam,
                                      size: 18,
                                      color: const Color(0xFF6C63FF),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      group['mode'] == 'Online'
                                          ? 'Switch to Face-to-Face'
                                          : 'Switch to Online',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Delete Group',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        // ⬆️ END NEW
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check,
                                  size: 14, color: Colors.green),
                              SizedBox(width: 4),
                              Text(
                                'Joined',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        : ElevatedButton(
                      onPressed: () => _joinGroup(group),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        minimumSize: const Size(0, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Join Group',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, bool isDarkMode) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: isDarkMode ? Colors.grey : Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDarkMode ? Colors.grey : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniAvatarCircle(String initials, Color color) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _joinGroup(Map<String, dynamic> group) {
    setState(() {
      group['joined'] = true;
      group['members'] = (group['members'] as int) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joined ${group['name']} successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _leaveGroup(Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (context) {
        final bool isDarkMode =
            Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          title: Text(
            'Leave Group',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to leave "${group['name']}"?',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
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
                setState(() {
                  group['joined'] = false;
                  group['members'] = (group['members'] as int) - 1;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Left ${group['name']}'),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );
  }

  // ⬇️ NEW: Change mode dialog (only for creator)
  void _showChangeModeDialog(Map<String, dynamic> group) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String currentMode = group['mode'];
    final String newMode =
    currentMode == 'Face-to-Face' ? 'Online' : 'Face-to-Face';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          title: Row(
            children: [
              Icon(
                newMode == 'Online' ? Icons.videocam : Icons.location_on,
                color: const Color(0xFF6C63FF),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Switch Delivery Mode',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Change "${group['name']}" from $currentMode to $newMode?',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
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
                setState(() {
                  group['mode'] = newMode;
                  // Auto-adjust location for the new mode
                  if (newMode == 'Online' &&
                      group['location'] != 'Zoom' &&
                      group['location'] != 'Google Meet') {
                    group['location'] = 'Zoom';
                  } else if (newMode == 'Face-to-Face' &&
                      (group['location'] == 'Zoom' ||
                          group['location'] == 'Google Meet')) {
                    group['location'] = 'TBD';
                  }
                });
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Switched to $newMode.'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
              ),
              child: const Text('Switch Mode'),
            ),
          ],
        );
      },
    );
  }

  // NEW: Delete group (only for creator)
  void _deleteGroup(Map<String, dynamic> group) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          title: Text(
            'Delete Group',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${group['name']}"? '
                'This action cannot be undone.',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
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
                setState(() {
                  _studyGroups.remove(group);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Group deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final locationController = TextEditingController();
    String selectedMode = 'Face-to-Face';
    TimeOfDay selectedTime = const TimeOfDay(hour: 18, minute: 0);

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor:
              isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
              title: Text(
                'Create Study Group',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
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
                        filled: true,
                        fillColor: isDarkMode
                            ? const Color(0xFF0A0A0A)
                            : const Color(0xFFF5F5F5),
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
                        labelText: 'Course Code (e.g., ICT725)',
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.grey : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: isDarkMode
                            ? const Color(0xFF0A0A0A)
                            : const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: locationController,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Location (Library, Zoom, etc.)',
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.grey : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: isDarkMode
                            ? const Color(0xFF0A0A0A)
                            : const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery Mode',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Face-to-Face', 'Online'].map((mode) {
                        final isSelected = selectedMode == mode;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () =>
                                  setDialogState(() => selectedMode = mode),
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF6C63FF)
                                      .withValues(alpha: 0.2)
                                      : (isDarkMode
                                      ? const Color(0xFF0A0A0A)
                                      : const Color(0xFFF5F5F5)),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF6C63FF)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    mode,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected
                                          ? const Color(0xFF6C63FF)
                                          : (isDarkMode
                                          ? Colors.grey
                                          : Colors.grey[600]),
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF0A0A0A)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 18,
                              color: Color(0xFF6C63FF),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Weekly at ${selectedTime.format(context)}',
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                    if (nameController.text.isNotEmpty &&
                        codeController.text.isNotEmpty) {
                      setState(() {
                        _studyGroups.insert(0, {
                          'name': nameController.text.trim(),
                          'code': codeController.text.trim().toUpperCase(),
                          'members': 1,
                          'mode': selectedMode,
                          'activity': 100,
                          'description':
                          'Study group for ${codeController.text}',
                          'schedule':
                          'Weekly at ${selectedTime.format(context)}',
                          'location': locationController.text.trim().isEmpty
                              ? (selectedMode == 'Online' ? 'Zoom' : 'TBD')
                              : locationController.text.trim(),
                          'joined': true,
                          'isCreated': true,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                  ),
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}