import 'package:flutter_riverpod/flutter_riverpod.dart';

// este provider provee al app, si el usuario desea sonido con sus mensajes de victoria o no.
final soundActivedProvider = StateProvider<bool>((ref) => true);
