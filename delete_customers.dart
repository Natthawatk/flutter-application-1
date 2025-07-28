import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

void main() async {
  print('🚀 Starting deletion process...');
  await deleteCustomers();
  print('✅ Process completed!');
}

Future<void> deleteCustomers() async {
  const String baseUrl = "http://192.168.182.236:3000";
  
  // Delete customers with idx 22 to 28
  for (int idx = 22; idx <= 28; idx++) {
    try {
      print('🗑️ Deleting customer with idx: $idx');
      
      final response = await http.delete(
        Uri.parse("$baseUrl/customers/$idx"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );
      
      print('📥 Delete response for idx $idx: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Successfully deleted customer idx: $idx');
      } else if (response.statusCode == 404) {
        print('⚠️ Customer idx $idx not found (already deleted or doesn\'t exist)');
      } else {
        print('❌ Failed to delete customer idx $idx: ${response.statusCode} - ${response.body}');
      }
      
      // Small delay between requests to avoid overwhelming the server
      await Future.delayed(Duration(milliseconds: 500));
      
    } catch (error) {
      print('❌ Error deleting customer idx $idx: $error');
    }
  }
  
  print('🏁 Finished deleting customers idx 22-28');
}