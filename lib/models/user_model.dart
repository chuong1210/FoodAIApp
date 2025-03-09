class UserModel {
  double? height; // cm
  double? weight; // kg
  double? targetWeight; // kg
  String? gender; // 'male', 'female', 'other'
  DateTime? birthDate; // New field for date of birth
  List<String> medicalConditions = [];
  List<String> allergies = [];
  String? dietType; // 'vegetarian', 'vegan', 'high_protein', 'balanced', etc.
  String?
      activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'

  UserModel({
    this.height,
    this.weight,
    this.targetWeight,
    this.gender,
    this.birthDate, // Added birthDate parameter
    this.medicalConditions = const [],
    this.allergies = const [],
    this.dietType,
    this.activityLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'targetWeight': targetWeight,
      'gender': gender,
      'birthDate': birthDate?.millisecondsSinceEpoch, // Store as timestamp
      'medicalConditions': medicalConditions,
      'allergies': allergies,
      'dietType': dietType,
      'activityLevel': activityLevel,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      height: json['height'],
      weight: json['weight'],
      targetWeight: json['targetWeight'],
      gender: json['gender'],
      birthDate: json['birthDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['birthDate'])
          : null,
      medicalConditions: List<String>.from(json['medicalConditions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      dietType: json['dietType'],
      activityLevel: json['activityLevel'],
    );
  }
}
