import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _purple = Color(0xFF4827E8);

/// Settings screen: profile fields and persisted app preferences.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.userName = 'Student'});

  final String userName;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  bool _darkMode = false;
  bool _notifications = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _nameController.text = prefs.getString('settings_user_name') ?? widget.userName;
      _emailController.text = prefs.getString('settings_user_email') ?? prefs.getString('email') ?? '';
      _darkMode = prefs.getBool('settings_dark_mode') ?? false;
      _notifications = prefs.getBool('notifications_enabled') ?? true;
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_user_name', _nameController.text.trim());
    await prefs.setString('settings_user_email', _emailController.text.trim());
    // Keep the existing email preference compatible with the menu header.
    await prefs.setString('email', _emailController.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile settings saved.')),
    );
  }

  Future<void> _setDarkMode(bool value) async {
    setState(() => _darkMode = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings_dark_mode', value);
  }

  Future<void> _setNotifications(bool value) async {
    setState(() => _notifications = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _purple,
      brightness: _darkMode ? Brightness.dark : Brightness.light,
    );
    return Theme(
      data: ThemeData(useMaterial3: true, colorScheme: scheme),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Row(children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: scheme.primaryContainer,
                          child: Text(
                            _nameController.text.trim().isEmpty
                                ? 'S'
                                : _nameController.text.trim()[0].toUpperCase(),
                            style: TextStyle(color: scheme.onPrimaryContainer, fontSize: 22),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_nameController.text, style: Theme.of(context).textTheme.titleLarge),
                            Text(_emailController.text.isEmpty ? 'Personal account' : _emailController.text),
                          ],
                        )),
                      ]),
                      const SizedBox(height: 24),
                      Text('PROFILE INFORMATION', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder()),
                            validator: (value) => value == null || value.trim().isEmpty ? 'Enter your name' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(labelText: 'Email address', border: OutlineInputBorder()),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty || !email.contains('@')) return 'Enter a valid email address';
                              return null;
                            },
                          ),
                        ]),
                      ),
                      const SizedBox(height: 24),
                      Text('PREFERENCES', style: Theme.of(context).textTheme.labelLarge),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.dark_mode_outlined),
                        title: const Text('Dark mode'),
                        value: _darkMode,
                        onChanged: _setDarkMode,
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.notifications_outlined),
                        title: const Text('Study notifications'),
                        value: _notifications,
                        onChanged: _setNotifications,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Privacy preferences'),
                            content: const Text('Your profile and preferences are stored locally on this device.'),
                            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                          ),
                        ),
                        icon: const Icon(Icons.privacy_tip_outlined),
                        label: const Align(alignment: Alignment.centerLeft, child: Text('Privacy preferences')),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: _purple, padding: const EdgeInsets.symmetric(vertical: 15)),
                        onPressed: _saveProfile,
                        child: const Text('Save changes'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
