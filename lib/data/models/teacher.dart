class Teacher {
  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.fcmId,
    required this.mobile,
    required this.image,
    required this.dob,
    required this.currentAddress,
    required this.permanentAddress,
    required this.status,
    required this.resetRequest,
    required this.qualification,
    required this.teacherId,
  });
  late final int id;
  late final String firstName;
  late final String lastName;
  late final String gender;
  late final String email;
  late final String fcmId;
  late final String mobile;
  late final String image;
  late final String dob;
  late final String currentAddress;
  late final String permanentAddress;
  late final int status;
  late final int resetRequest;
  late final String qualification;
  late final int teacherId;

  Teacher.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    gender = json['gender'] ?? "";
    email = json['email'] ?? "";
    fcmId = json['fcm_id'] ?? "";
    mobile = json['mobile'] ?? "";
    image = json['image'] ?? "";
    dob = json['dob'] ?? "";
    currentAddress = json['current_address'] ?? "";
    permanentAddress = json['permanent_address'] ?? "";
    status = json['status'] ?? 0;
    resetRequest = json['reset_request'] ?? 0;
    teacherId = (json['teacher'] != null) ? json['teacher']['id'] : 0;
    qualification =
        (json['teacher'] != null) ? json['teacher']['qualification'] : "";
  }

  String getFullName() {
    return "$firstName $lastName";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['email'] = email;
    data['fcm_id'] = fcmId;
    data['mobile'] = mobile;
    data['image'] = image;
    data['dob'] = dob;
    data['current_address'] = currentAddress;
    data['permanent_address'] = permanentAddress;
    data['status'] = status;
    data['reset_request'] = resetRequest;
    data['teacher'] = {"id": teacherId, "qualification": qualification};
    return data;
  }
}
