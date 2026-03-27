class UserModel {
  final String name;
  final String email;
  final double height; // cm
  final double weight; // kg
  final int age;
  final String gender;
  final String goal;
  final String? profileImageUrl;
  final bool isPro;

  UserModel({
    required this.name,
    required this.email,
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.goal,
    this.profileImageUrl,
    this.isPro = false,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    final b = bmi;
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Healthy Weight';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }

  UserModel copyWith({
    String? name,
    String? email,
    double? height,
    double? weight,
    int? age,
    String? gender,
    String? goal,
    String? profileImageUrl,
    bool? isPro,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPro: isPro ?? this.isPro,
    );
  }
}
