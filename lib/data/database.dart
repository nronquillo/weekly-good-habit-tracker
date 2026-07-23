import 'package:drift/drift.dart';

part 'database.g.dart';

// ─── Habits ───────────────────────────────────────────────
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();

  // 'hours' or 'segments' — stored as text, mapped via an enum in Dart
  TextColumn get type => textEnum<HabitType>()();

  IntColumn get weeklyGoal => integer()(); // number of blocks/week
  IntColumn get color => integer()(); // ARGB value
  TextColumn get icon => text().nullable()(); // icon key/codepoint

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

enum HabitType { hours, segments }

// ─── Habit Entries ────────────────────────────────────────
class HabitEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get habitId => integer().references(Habits, #id)();

  // date-only — the day this entry counts toward (user-editable)
  DateTimeColumn get date => dateTime()();

  // raw value: hours logged (e.g. 1.5) or 1.0 for a segment entry
  RealColumn get value => real()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get loggedAt => dateTime().withDefault(currentDateAndTime)();
}

// ─── Database ─────────────────────────────────────────────
@DriftDatabase(tables: [Habits, HabitEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}
