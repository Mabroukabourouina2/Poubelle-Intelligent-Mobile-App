class UserModel {
  final String uid;
  final String email;
  final String name;
  final String rfid;
  final int score;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.rfid,
    required this.score,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      rfid: data['rfid'] ?? '',
      score: data['score'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'rfid': rfid,
      'score': score,
    };
  }
}
