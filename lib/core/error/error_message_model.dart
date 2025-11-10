class ErrorMessageModel {
  final int status;
  final String error;

  const ErrorMessageModel({
    required this.status,
    required this.error,
  });

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(
      status: json['status'],
      error:json['error']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['error'] = error;
    return json;
  }
}