class UserModel {
  double? height; // cm
  double? weight; // kg
  double? targetWeight; // kg
  String? gender; // 'male', 'female', 'other'
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
    List<String>? medicalConditions,
    List<String>? allergies,
    this.dietType,
    this.activityLevel,
  }) {
    this.medicalConditions = medicalConditions ?? [];
    this.allergies = allergies ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'targetWeight': targetWeight,
      'gender': gender,
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
      medicalConditions: List<String>.from(json['medicalConditions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      dietType: json['dietType'],
      activityLevel: json['activityLevel'],
    );
  }
}
