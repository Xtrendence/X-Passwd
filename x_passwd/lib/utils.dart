import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:randombytes/randombytes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
	Utils();
	
	save(String title, String url, String password, String notes) async {
		String id = generateID();
		
		Object object = { title:title, url:url, password:password, notes:notes };
		
		String json = jsonEncode(object);
		
		String encrypted = await aesEncrypt(json, getPassword());
		
		FlutterSecureStorage storage = new FlutterSecureStorage();
		
		await storage.write(key:id, value:encrypted);
	}
	
	read() async {
		FlutterSecureStorage storage = new FlutterSecureStorage();

		Object stored = await storage.readAll();
		
		return jsonEncode(stored);
	}
	
	aesEncrypt(String plaintext, String password) async {
		Key key = Key.fromUtf8(password);
		IV iv = IV.fromLength(16);
		
		Encrypter aes = Encrypter(AES(key, mode: AESMode.ctr));
		
		return jsonEncode({ "ciphertext":aes.encrypt(plaintext, iv: iv).base64, "iv":iv });
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
	
	vaultExists() async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		Map<String, String> values = await storage.readAll();
		if(values.keys.length > 0) {
			return true;
		}
		return false;
	}
	
	generateID() {
		String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
		return timestamp + "-" + randomBytes(10).toString();
	}
	
	notify(Material.BuildContext context, String text) {
		Material.Scaffold.of(context).showSnackBar(Material.SnackBar(
			content: Material.Text(text),
		));
	}
}