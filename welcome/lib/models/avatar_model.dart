class Avatar {
  final String interest;
  final String? rive;

  Avatar({required this.interest, this.rive});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      interest: json['interest'],
      rive: json['rive'],
    );
  }
}
