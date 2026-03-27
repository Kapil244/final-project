class WorkoutModel {
  final String id;
  final String name;
  final String category;
  final int duration; // minutes
  final int calories;
  final String difficulty;
  final String description;
  final String imageUrl;
  final bool isFavorite;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.calories,
    required this.difficulty,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });

  WorkoutModel copyWith({bool? isFavorite, String? imageUrl}) {
    return WorkoutModel(
      id: id,
      name: name,
      category: category,
      duration: duration,
      calories: calories,
      difficulty: difficulty,
      description: description,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class WorkoutLogEntry {
  final String workoutName;
  final int calories;
  final DateTime date;
  final int duration;

  WorkoutLogEntry({
    required this.workoutName,
    required this.calories,
    required this.date,
    required this.duration,
  });
}

class ProgramModel {
  final String id;
  final String name;
  final String category;
  final int weeks;
  final int currentDay;
  final int totalDays;
  final String difficulty;
  final int calories;
  final int duration;
  final String imageUrl;

  ProgramModel({
    required this.id,
    required this.name,
    required this.category,
    required this.weeks,
    required this.currentDay,
    required this.totalDays,
    required this.difficulty,
    required this.calories,
    required this.duration,
    required this.imageUrl,
  });

  double get progress => currentDay / totalDays;
}
class ActivityDataPoint {
  final int hour; // 0-23
  final int steps;
  final int calories;
  final int minutes;
  final double water; // in glasses

  ActivityDataPoint({
    required this.hour,
    required this.steps,
    required this.calories,
    required this.minutes,
    required this.water,
  });
}
