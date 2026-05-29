class BaseResponse<T> {
  final bool error;
  final String msg;
  final T? data;

  BaseResponse({
    required this.error,
    required this.msg,
    this.data,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return BaseResponse<T>(
      error: json['error'] ?? false,
      msg: json['msg'] ?? json['status'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
    );
  }
}
