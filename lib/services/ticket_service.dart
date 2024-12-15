class TicketService {
  static const String baseUrl = 'http://3.137.100.242:3000/api/v1/tickets';

  Future<List<ServiceTicket>> fetchServiceTickets() async {
    try {
      final response = await _makeRequest('GET', '$baseUrl?include=serviceCall');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((item) => ServiceTicket.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load service tickets');
      }
    } catch (e) {
      throw Exception('Error fetching service tickets: $e');
    }
  }

  Future<ServiceTicket> fetchServiceTicketById(String idTicket) async {
    try {
      final response = await _makeRequest('GET', '$baseUrl/$idTicket?include=serviceCall');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Map<String, dynamic> data = jsonResponse['data'];
        print('data $data');

        return ServiceTicket.fromJson(data);
      } else {
        throw Exception('Failed to load service ticket');
      }
    } catch (e) {
      throw Exception('Error fetching service ticket: $e');
    }
  }

  Future<void> updateTickets(String idTicket, Map<String, dynamic> data) async {
    try {
      final response = await _makeRequest('PUT', '$baseUrl/$idTicket', body: data);

      if (response.statusCode == 200) {
        print("Detalles guardados con éxito $data");
        // Acciones adicionales después de guardar
      } else {
        print("Error al guardar los detalles: ${response.body}");
      }
    } catch (e) {
      print("Error al conectar con el servidor: $e");
    }
  }

  Future<void> sendFile(File file, String modelType, String modelId, String collectionName) async {
    String? token = await _getToken();
    final uri = Uri.parse('http://3.137.100.242:3000/api/v1/media');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['model_type'] = modelType
      ..fields['model_id'] = modelId
      ..fields['collection_name'] = collectionName
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('image', 'webp'),
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Archivo enviado exitosamente.');
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Error al enviar el archivo: ${response.statusCode}');
        print('Respuesta del servidor: $responseBody');
      }
    } on http.ClientException catch (e) {
      print('ClientException: $e');
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
  }

  Future<void> saveFormData(String date, String observations, List<File> images, String idTicket) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateTime dateTime = dateFormat.parse(date.replaceAll('/', '-'));

    Map<String, dynamic> formData = {
      'diagnosis_date': dateFormat.format(dateTime),
      'diagnosis_detail': observations,
    };

    try {
      final response = await _makeRequest('PUT', '$baseUrl/$idTicket', body: formData);

      if (response.statusCode == 200) {
        print('Datos guardados exitosamente.');
        Fluttertoast.showToast(
          msg: "Datos guardados exitosamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        for (File image in images) {
          await sendFile(image, 'Ticket', idTicket, 'diagnostic');
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error al guardar los datos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error al enviar la solicitud",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> savecloseTicketFormData(String date, String observations, List<File> images, String idTicket) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateTime dateTime = dateFormat.parse(date.replaceAll('/', '-'));

    Map<String, dynamic> formData = {
      'solution_date': dateFormat.format(dateTime),
      'solution_detail': observations,
      'status': 2,
    };

    try {
      final response = await _makeRequest('PUT', '$baseUrl/$idTicket', body: formData);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Datos guardados exitosamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Error al guardar los datos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error al enviar la solicitud",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
