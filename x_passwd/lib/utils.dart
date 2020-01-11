import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:randombytes/randombytes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
	Utils();
	
	save(String title, String url, String password, String notes) async {
		String id = generateID();
		
		Object object = { title:title, url:url, password:password, notes:notes };
		
		String json = jsonEncode(object);
		
		String encrypted = await aesEncrypt(json, password);
	
		SharedPreferences preferences = await SharedPreferences.getInstance();
		
		preferences.setString(id, encrypted);
	}
	
	read() async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		
		Map<String, String> object = {};
		
		var keys = preferences.getKeys().toList();
		
		for(int i = 0; i < keys.length; i++) {
			object[keys[i]] = preferences.getString(keys[i]);
		}
		
		return jsonEncode(object);
	}
	
	aesEncrypt(String plaintext, String password) async {
		Key key = Key.fromUtf8(password);
		IV iv = IV.fromLength(16);
		
		Encrypter aes = Encrypter(AES(key, mode: AESMode.ctr));
		
		return aes.encrypt(plaintext, iv: iv).base64;
	}
	
	aesDecrypt(String ciphertext, String password, IV iv) async {
		Key key = Key.fromUtf8(password);
		
		Encrypter aes = Encrypter(AES(key, mode: AESMode.ctr));
		
		Encrypted encrypted = Encrypted.fromBase64(ciphertext);
		
		return aes.decrypt(encrypted, iv: iv);
	}

	setPassword(String password) async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		await storage.write(key:"password", value:password);
	}

	getPassword() async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		return await storage.read(key:"password");
	}
	
	generateID() {
		String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
		return timestamp + "-" + randomBytes(10).toString();
	}
}