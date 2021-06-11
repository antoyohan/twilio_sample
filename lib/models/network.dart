class Response{
  int _statusCode;

  int get statusCode => _statusCode;

  Response(this._statusCode);
}

class Success<T> extends Response {
  T data;

  Success(this.data,int statusCode): super(statusCode);
}

class Error extends Response {

  Error(int statusCode): super(statusCode);
}