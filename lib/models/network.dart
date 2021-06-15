class Response<T>{
  int _statusCode;
  T _data;
  int get statusCode => _statusCode;

  T get data => _data;

  Response(this._statusCode, this._data);
}

class Success<T> extends Response {
  Success(int statusCode, T data,): super(statusCode, data);
}

class Error<T> extends Response {

  Error(int statusCode, T data): super(statusCode, data);
}