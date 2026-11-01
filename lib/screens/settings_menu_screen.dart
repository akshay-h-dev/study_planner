import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color _purple = Color(0xFF4827E8);
const Color _ink = Color(0xFF20264D);
const Color _muted = Color(0xFF7B83A8);
const Color _page = Color(0xFFF7F8FC);
const Color _border = Color(0xFFE1E5F4);

/// App menu screen based on the Study Planner menu design.
class SettingsMenuScreen extends StatefulWidget {
  const SettingsMenuScreen({super.key, this.userName = 'Student'});

  final String userName;

  @override
  State<SettingsMenuScreen> createState() => _SettingsMenuScreenState();
}

class _SettingsMenuScreenState extends State<SettingsMenuScreen> {
  bool _notificationsEnabled = true;
  String _email = '';
  bool _loadingPreferences = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
        _email = prefs.getString('email') ?? '';
        _loadingPreferences = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingPreferences = false);
    }
  }

  Future<void> _setNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notifications_enabled', value);
    } catch (_) {
      if (mounted) _showMessage('Could not save notification preference.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Study Planner',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.menu_book_rounded, color: _purple),
      children: const [
        Text(
          'Plan your study sessions, track progress, and build consistent habits.',
        ),
      ],
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You will return to the login screen. Your saved study tasks will remain on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _purple),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Clear the active-session preference only. Do not clear all preferences:
    // that could erase the user's locally saved study tasks.
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');
      await prefs.remove('logged_in');
    } catch (_) {
      // Continue to login even if a session preference could not be removed.
    }

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color iconColor = _purple,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFEAE7FF),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: _ink,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, style: const TextStyle(color: _muted, fontSize: 12)),
      trailing:
          trailing ?? const Icon(Icons.chevron_right_rounded, color: _muted),
      onTap: onTap,
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 7),
      child: Text(
        text,
        style: const TextStyle(
          color: _muted,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.userName.trim().isEmpty
        ? 'Student'
        : widget.userName.trim();

    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: _page,
        title: const Text(
          'Menu',
          style: TextStyle(color: _ink, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded, color: _ink),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _purple,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 27,
                        backgroundColor: Color(0xFF6D59EF),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 29,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hey, $displayName.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _loadingPreferences
                                  ? ' '
                                  : (_email.isEmpty
                                        ? 'Make your next study session count.'
                                        : _email),
                              style: const TextStyle(
                                color: Color(0xFFDCD7FF),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _sectionLabel('YOUR STUDY SPACE'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: _border),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _menuItem(
                        icon: Icons.dashboard_outlined,
                        title: 'Dashboard',
                        subtitle: 'Your study overview',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const Divider(height: 1, indent: 72, color: _border),
                      _menuItem(
                        icon: Icons.bookmark_border_rounded,
                        title: 'Favorites',
                        subtitle: 'Your saved study tasks',
                        onTap: () => _showMessage(
                          'Open Saved from the Home navigation to view saved tasks.',
                        ),
                      ),
                      const Divider(height: 1, indent: 72, color: _border),
                      _menuItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Profile',
                        subtitle: 'Your account information',
                        onTap: () => _showMessage(
                          'Profile screen is not connected yet.',
                        ),
                      ),
                      const Divider(height: 1, indent: 72, color: _border),
                      _menuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'Account and app preferences',
                        onTap: () => _showMessage(
                          'Settings screen is not connected yet.',
                        ),
                      ),
                      const Divider(height: 1, indent: 72, color: _border),
                      _menuItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        subtitle: 'Study reminders and alerts',
                        trailing: Switch(
                          value: _notificationsEnabled,
                          activeColor: _purple,
                          onChanged: _setNotifications,
                        ),
                        onTap: () => _setNotifications(!_notificationsEnabled),
                      ),
            
                      const Divider(height: 1, indent: 72, color: _border),
                      _menuItem(
                        icon: Icons.public_rounded,
                        title: 'Integrate API',
                        subtitle: 'Explore countries around the world',
                        onTap: () => _showMessage(
                          'Use Explore Countries from the Home drawer to open the API feature.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: _border),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _menuItem(
                        icon: Icons.info_outline_rounded,
                        title: 'About Study Planner',
                        subtitle: 'Version 1.0.0',
                        onTap: _showAbout,
                      ),
                      const Divider(height: 1, indent: 72, color: _border),
                      _menuItem(
                        icon: Icons.logout_rounded,
                        title: 'Sign Out',
                        subtitle: 'Return to the login screen',
                        iconColor: Colors.redAccent,
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.redAccent,
                        ),
                        onTap: _confirmLogout,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Small steps. Stronger semesters.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
