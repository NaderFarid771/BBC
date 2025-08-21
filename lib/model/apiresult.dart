class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String? error;

  ApiResult._({
    required this.isSuccess,
    this.data, 
    this.error});
  factory ApiResult.success(T data) {
    return ApiResult._(isSuccess: true, data: data);
  }
  
  factory ApiResult.failure(String error) {
    return ApiResult._(isSuccess: false, error: error);
  }
}