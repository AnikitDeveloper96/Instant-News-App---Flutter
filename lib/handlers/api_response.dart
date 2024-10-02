enum Status {loading, completed, error}

class ApiResponse<T> {

  Status status;
  String? message;
  T? data;

  ApiResponse.loading(this.message) : status = Status.loading;
  ApiResponse.error(this.message) : status = Status.error;
  ApiResponse.completed(this.data) : status = Status.completed;

  @override
  String toString() {
    return "Status: $status \n Message: $message \n Data: $data";
  }

}