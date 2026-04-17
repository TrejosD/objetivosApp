import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/infrastructure/helpers/shared_preferences_service.dart';
import 'package:objetivos/presentations/providers/sound_actived_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

// este screen tiene los cambios de configuracion del app, como lenguaje, sonido, tema claro\oscuro
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isSoundActived = ref.watch(soundActivedProvider);
    final prefs = SharedPreferencesService.prefs;
    final String? savedLocale = prefs.getString('locale');
    final String? savedStyle = prefs.getString('brightness');
    final List<String> styleItems = [
      'styleList.1'.tr(),
      'styleList.2'.tr(),
      'styleList.3'.tr(),
    ];
    final List<String> localeList = [
      'localeList.1'.tr(),
      'localeList.2'.tr(),
      'localeList.3'.tr(),
      'localeList.4'.tr(),
      'localeList.5'.tr(),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('newLeaf - Settings')),
      body: Column(
        children: [
          Row(
            children: [
              Icon(Icons.sunny),
              Text('styleLabel'.tr()),
              DropdownMenu(
                initialSelection: savedStyle ?? 'styleList.1'.tr(),
                dropdownMenuEntries: styleItems.map((item) {
                  return DropdownMenuEntry(value: item, label: item);
                }).toList(),
                onSelected: (item) async {
                  final prefs = await SharedPreferences.getInstance();
                  if (item == 'styleList.1'.tr()) {
                    await prefs.remove('brightness');
                    Restart.restartApp();
                  } else {
                    await prefs.setString('brightness', item.toString());
                    Restart.restartApp();
                  }
                },
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.language_rounded),
              Text('languageLabel'.tr()),
              DropdownMenu(
                initialSelection: savedLocale ?? 'localeList.1'.tr(),
                onSelected: (locale) async {
                  final prefs = await SharedPreferences.getInstance();
                  if (locale == 'localeList.1'.tr()) {
                    prefs.remove('locale');
                    Restart.restartApp();
                  } else {
                    await prefs.setString('locale', locale.toString());
                    Restart.restartApp();
                  }
                },
                dropdownMenuEntries: localeList.map((locale) {
                  return DropdownMenuEntry(value: locale, label: locale);
                }).toList(),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.speaker_phone_outlined),
              Text('Sonido Activado'),
              Switch(
                value: isSoundActived,
                onChanged: (value) {
                  setState(() {
                    ref.read(soundActivedProvider.notifier).state = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      // cada setting seria un row ( icon / text / option)
    );
  }
}
