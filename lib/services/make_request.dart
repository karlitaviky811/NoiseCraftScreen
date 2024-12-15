Future<http.Response> _makeRequest(String method, String url, {Map<String, dynamic>? body}) async {
  String? token = await _getToken();
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  switch (method) {
    case 'GET':
      return await http.get(Uri.parse(url), headers: headers);
    case 'PUT':
      return await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));
    default:
      throw UnsupportedError('Unsupported HTTP method: $method');
  }
}
