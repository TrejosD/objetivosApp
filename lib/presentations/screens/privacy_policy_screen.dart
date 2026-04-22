import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 14),
        child: ListView(
          children: [
            Text('Last updated: 21/4/2026'),
            Text(
              'NewLeaf we respects your privacy. This Privacy Policy explains how our mobile application (the "App"), developed with Flutter and distributed through the Google Play Store, handles your information.',
            ),
            // titulo
            Text('1. Information We Collect'),
            Text(
              'We do not collect or store personal data on external servers.',
            ),
            Text(
              'All data generated or entered in the App is stored locally on your device only.',
            ),
            // subtitulo
            Text('This may include:'),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text(
                      'User-created content (e.g., goals, notes, progress data)',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text('App preferences and settings'),
                  ],
                ),
              ],
            ),
            // subtitulo
            Text('We do not collect:'),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text('Personal identifiable information (PII)'),
                  ],
                ),
                Row(children: [Icon(Icons.circle), Text('Location data')]),
                Row(children: [Icon(Icons.circle), Text('Contacts')]),
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text('Financial or sensitive data'),
                  ],
                ),
              ],
            ),
            // titulo
            Text('2. Local Data Storage'),
            // subtitulos
            Text(
              'All information is stored securely on your device using local storage mechanisms (e.g., databases or files).',
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text('We do not have access to this data'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text(
                      'We do not transmit this data to any external servers',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text(
                      'If you uninstall the App, your data may be permanently deleted',
                    ),
                  ],
                ),
              ],
            ),
            // titulo
            Text('3. Permissions We Use'),

            Text(
              'The App requests the following permissions strictly for functionality:',
            ),
            // subtitulo
            Text('• INTERNET (android.permission.INTERNET)'),
            Text('Used only for:'),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text(
                      'Basic app functionality if needed by system components',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text('No user data is transmitted to external servers'),
                  ],
                ),
              ],
            ),
            Text(
              '• RECEIVE_BOOT_COMPLETED (android.permission.RECEIVE_BOOT_COMPLETED)',
            ),
            Text('Used to:'),
            Row(
              children: [
                Icon(Icons.circle),
                Text('Restore scheduled notifications after device restart'),
              ],
            ),
            Text(
              '• SCHEDULE_EXACT_ALARM (android.permission.SCHEDULE_EXACT_ALARM)',
            ),
            Text('• USE_EXACT_ALARM (android.permission.USE_EXACT_ALARM)'),
            Text('Used to:'),
            Row(
              children: [
                Icon(Icons.circle),
                Text(
                  'Schedule precise reminders and notifications related to your activities in the App',
                ),
              ],
            ),
            Text(
              'We do not use these permissions for tracking, profiling, or advertising.',
            ),
            // titutlo
            Text('4. Data Sharing'),
            Text(
              'We do not share, sell, or transfer any user data to third parties.',
            ),
            // titulos
            Text('5. Data Security'),
            Text('Since all data is stored locally:'),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text(
                      'You are responsible for maintaining the security of your device',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text('We do not transmit or store your data externally'),
                  ],
                ),
              ],
            ),
            // titulo
            Text('6. Third-Party Services'),
            Text(
              'This App does not use third-party services that collect user data.',
            ),
            Divider(),
            Text('7. User Control'),
            Text('You have full control over your data:'),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text(
                      'You can delete your data by clearing the app storage or uninstalling the App',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text(
                      'You can disable notifications at any time from your device settings',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.circle),
                    Text(
                      'You can revoke permissions through your device settings',
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            // titulo
            Text('8. Children`s Privacy'),
            Text(
              'This App is not directed to children under the age of 13. We do not knowingly collect any personal data from children.',
            ),
            Divider(),
            Text('9. Changes to This Privacy Policy'),
            Text(
              'We may update this Privacy Policy from time to time. Any changes will be reflected by updating the "Last updated" date.',
            ),
            Divider(),
            Text('10. Contact'),
            Text(
              'If you have any questions about this Privacy Policy, you can contact us at:',
            ),
            Text('Email: d.trejosh@gmail.com'),
          ],
          // todo colocar un divider entre cada seccion
        ),
      ),
    );
  }
}
