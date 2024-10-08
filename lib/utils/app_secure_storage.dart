import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecureStorage{

  // Create a singleton instance of FlutterSecureStorage
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Store the access token securely
  static Future<void> storeAccessToken(String token) async {
    try{
      await _storage.write(key: 'access_token', value: token);
    }catch(e){
      log('Error access token: $e');
    }
  }

  // Retrieve the access token
  static Future<String?> getAccessToken() async {
    try{
      return await _storage.read(key: 'access_token');
    }catch(e){
      log('Error access token: $e');
      return null;
    }
  }

  // Delete the access token
  static Future<void> deleteAccessToken() async {
    try{
      await _storage.delete(key: 'access_token');
    }catch(e){
      log('Error access token: $e');
    }
  }
}