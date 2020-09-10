class _StatusCodeDetail {
  final int code;
  final bool panic;
  final String message;

  const _StatusCodeDetail({
    this.code, this.panic, this.message
  });

  @override toString() => 'StatusCode(code=$code, message=$message, panic=$panic)';
}

const _statusCodes = <int, _StatusCodeDetail>{
  200: const _StatusCodeDetail(code: 200, message: 'OK'),
  201: const _StatusCodeDetail(code: 201, message: 'Created'),
  204: const _StatusCodeDetail(code: 204, panic: true, message: 'No Content'),

  400: const _StatusCodeDetail(code: 400, panic: true, message: 'Bad Request'),
  401: const _StatusCodeDetail(code: 401, panic: true, message: 'Unauthorized'),
  402: const _StatusCodeDetail(code: 402, panic: true, message: 'Payment Required'),
  403: const _StatusCodeDetail(code: 403, panic: true, message: 'Forbidden'),
  404: const _StatusCodeDetail(code: 404, panic: true, message: 'Not Found'),

  500: const _StatusCodeDetail(code: 500, panic: true, message: 'Internal Server Error')
};

handleStatusCode(int statusCode) {
  final codeDetails = _statusCodes[statusCode];
  print(codeDetails);

  if (codeDetails.panic) {
    throw codeDetails;
  }
}
