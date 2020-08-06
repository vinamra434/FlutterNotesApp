class GenericApiResponse<T> {
  T data;
  bool error;
  String message;

  GenericApiResponse({this.data, this.error = false, this.message});
}
