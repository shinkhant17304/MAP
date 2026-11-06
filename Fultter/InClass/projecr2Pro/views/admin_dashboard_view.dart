import 'package:flutter/material.dart';

import 'learner_store.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  List<LearnerProfile> _learners = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedLevel = 'All levels';

  @override
  void initState() {
    super.initState();
    _loadLearners();
  }

  Future<void> _loadLearners() async {
    final learners = await LearnerStore.instance.getAll();
    if (!mounted) return;
    setState(() {
      _learners = learners;
      _isLoading = false;
    });
  }

  Future<void> _editLearner(LearnerProfile learner) async {
    final updatedLearner = await showDialog<LearnerProfile>(
      context: context,
      builder: (_) => _EditLearnerDialog(learner: learner),
    );
    if (updatedLearner == null) return;

    await LearnerStore.instance.update(updatedLearner);
    if (!mounted) return;
    setState(() {
      _learners = [
        for (final item in _learners)
          if (item.id == updatedLearner.id) updatedLearner else item,
      ];
    });
  }

  String _joinedDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return 'Unknown';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _showLearnerDetails(LearnerProfile learner) async {
    final shouldEdit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(learner.fullName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(Icons.email_outlined, 'Email', learner.email),
            _detailRow(
              Icons.phone_outlined,
              'Phone',
              learner.phone.isEmpty ? 'Not set' : learner.phone,
            ),
            _detailRow(Icons.school_outlined, 'CEFR level', learner.level),
            _detailRow(
              Icons.calendar_today_outlined,
              'Joined',
              _joinedDate(learner.joinedAt),
            ),
            _detailRow(Icons.badge_outlined, 'Learner ID', learner.id),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit details'),
          ),
        ],
      ),
    );
    if (shouldEdit == true) await _editLearner(learner);
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF0056C6)),
          const SizedBox(width: 12),
          SizedBox(
            width: 82,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0056C6)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12)),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredLearners =
        _learners.where((learner) {
          final query = _searchQuery.toLowerCase();
          final matchesSearch =
              learner.fullName.toLowerCase().contains(query) ||
              learner.email.toLowerCase().contains(query);
          final matchesLevel =
              _selectedLevel == 'All levels' || learner.level == _selectedLevel;
          return matchesSearch && matchesLevel;
        }).toList()..sort(
          (first, second) => first.fullName.compareTo(second.fullName),
        );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Learners',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Text('${_learners.length} total'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    icon: Icons.people_outline,
                    label: 'Registered learners',
                    value: '${_learners.length}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    icon: Icons.school_outlined,
                    label: 'Levels in use',
                    value:
                        '${_learners.map((learner) => learner.level).toSet().length}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search name or email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value.trim()),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _selectedLevel,
              decoration: const InputDecoration(
                labelText: 'Filter by level',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const ['All levels', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2']
                  .map(
                    (level) =>
                        DropdownMenuItem(value: level, child: Text(level)),
                  )
                  .toList(),
              onChanged: (level) {
                if (level != null) setState(() => _selectedLevel = level);
              },
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredLearners.isEmpty
                  ? Center(
                      child: Text(
                        _learners.isEmpty
                            ? 'No learners registered yet.'
                            : 'No learners match your search.',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredLearners.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final learner = filteredLearners[index];
                        final initials = learner.fullName
                            .trim()
                            .split(RegExp(r'\s+'))
                            .where((part) => part.isNotEmpty)
                            .take(2)
                            .map((part) => part[0].toUpperCase())
                            .join();
                        return Card(
                          child: ListTile(
                            onTap: () => _showLearnerDetails(learner),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFEBF3FF),
                              foregroundColor: const Color(0xFF0056C6),
                              child: Text(initials.isEmpty ? '?' : initials),
                            ),
                            title: Text(learner.fullName),
                            subtitle: Text(
                              '${learner.email}\n'
                              'Phone: ${learner.phone.isEmpty ? 'Not set' : learner.phone}\n'
                              'Level: ${learner.level} · Joined: ${_joinedDate(learner.joinedAt)}',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              tooltip: 'Edit learner details',
                              onPressed: () => _editLearner(learner),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditLearnerDialog extends StatefulWidget {
  const _EditLearnerDialog({required this.learner});

  final LearnerProfile learner;

  @override
  State<_EditLearnerDialog> createState() => _EditLearnerDialogState();
}

class _EditLearnerDialogState extends State<_EditLearnerDialog> {
  late final _nameController = TextEditingController(
    text: widget.learner.fullName,
  );
  late final _emailController = TextEditingController(
    text: widget.learner.email,
  );
  late final _phoneController = TextEditingController(
    text: widget.learner.phone,
  );
  final _formKey = GlobalKey<FormState>();
  late String _level = widget.learner.level;
  bool _duplicateEmail = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final existing = await LearnerStore.instance.findByEmail(
      _emailController.text.trim(),
    );
    if (existing != null && existing.id != widget.learner.id) {
      setState(() => _duplicateEmail = true);
      return;
    }
    if (!mounted) return;
    Navigator.pop(
      context,
      widget.learner.copyWith(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        level: _level,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit learner details'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a name'
                    : null,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _duplicateEmail ? 'Email already in use' : null,
                ),
                onChanged: (_) => setState(() => _duplicateEmail = false),
                validator: (value) => value == null || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              DropdownButtonFormField<String>(
                initialValue: _level,
                decoration: const InputDecoration(labelText: 'CEFR level'),
                items: const ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
                    .map(
                      (level) =>
                          DropdownMenuItem(value: level, child: Text(level)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _level = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save changes')),
      ],
    );
  }
}
