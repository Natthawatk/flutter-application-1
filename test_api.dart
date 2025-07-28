import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'lib/config/api_config.dart';

void main() async {
  print('🧪 Testing API connections...');
  
  // Test 1: Get customers
  await testGetCustomers();
  
  // Test 2: Test login
  await testLogin();
  
  print('✅ API tests completed!');
}

Future<void> testGetCustomers() async {
  try {
    print('\n📋 Testing GET customers...');
    final response = await http.get(
      Uri.parse(ApiConfig.customersUrl),
      headers: ApiConfig.headers,
    );
    
    print('Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ GET customers successful - Found ${data.length} customers');
    } else {
      print('❌ GET customers failed: ${response.body}');
    }
  } catch (error) {
    print('❌ GET customers error: $error');
  }
}

Future<void> testLogin() async {
  try {
    print('\n🔐 Testing login...');
    final response = await http.post(
      Uri.parse(ApiConfig.loginUrl),
      headers: ApiConfig.headers,
      body: json.encode({
        "phone": "0817399999",
        "password": "1111"
      }),
    );
    
    print('Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Login successful - User: ${data['customer']['fullname']}');
    } else {
      print('❌ Login failed: ${response.body}');
    }
  } catch (error) {
    print('❌ Login error: $error');
  }
}