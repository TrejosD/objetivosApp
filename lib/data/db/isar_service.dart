import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:objetivos/data/entities/entities.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      GoalMontlySchema,
      GoalSchema,
      GoalHistorySchema,
    ], directory: dir.path);
  }
}
