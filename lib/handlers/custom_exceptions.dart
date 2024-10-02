class CustomExceptions implements Exception {
  final String? _message;

  CustomExceptions([this._message]);

  @override
  String toString() {
    return "$_message";
  }
}

class FetchDataException extends CustomExceptions {
  FetchDataException([String? message]) : super(message);
}

class BadRequestException extends CustomExceptions {
  BadRequestException([message]) : super(message);
}

class UnProcessableException extends CustomExceptions {
  UnProcessableException([message]) : super(message);
}

class UnauthorisedException extends CustomExceptions {
  UnauthorisedException([message]) : super(message);
}

class NotFoundException extends CustomExceptions {
  NotFoundException([message]) : super(message);
}

class InvalidInputException extends CustomExceptions {
  InvalidInputException([String? message]) : super(message);
}