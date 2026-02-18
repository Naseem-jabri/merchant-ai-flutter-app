import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  
  //Base URL for the Flask Server
  //If using Android Emulator, change 127.0.0.1 to 10.0.2.2
  final String baseUrl = 'http://127.0.0.1:5000';

  //Analyze text using AI Model
  Future<Map<String, dynamic>> analyzeComment(String comment) async {
    try {
      final response = await _dio.post(
        '$baseUrl/predict', 
        data: {'text': comment},
      );
      return response.data;
    } catch (e) {
      print("Error: AI Prediction failed - $e");
      return {'label': 'Error connecting to AI Server'};
    }
  }

  //User Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      print("Login successful for: $email");
      return response.data; 
    } catch (e) {
      print("Login Error: Invalid credentials or server unreachable");
      return {'error': 'Invalid credentials or server down'};
    }
  }

  //New Account Registration (Sign Up)
  Future<Map<String, dynamic>> signUp(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/signup',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      print("Registration successful for: $email");
      return response.data;
    } catch (e) {
      print("Sign Up Error: Failed to create account");
      return {'error': 'Failed to create account'};
    }
  }


  //Save a new analysis record to the database
  Future<void> saveAnalysis(String email, String comment, String result) async {
    try {
      await _dio.post(
        '$baseUrl/save_analysis',
        data: {
          'email': email,
          'comment': comment,
          'result': result,
        },
      );
      print("Success: Analysis saved to database");
    } catch (e) {
      print("Error: Could not save analysis to database - $e");
    }
  }

  //Fetch previous analysis records for a specific user
  Future<List<dynamic>> fetchHistory(String email) async {
    try {
      final response = await _dio.get('$baseUrl/get_history/$email');
      print("Success: Fetched ${response.data.length} records for $email");
      return response.data;
    } catch (e) {
      print("Error: Failed to fetch history records - $e");
      return [];
    }
  }
}