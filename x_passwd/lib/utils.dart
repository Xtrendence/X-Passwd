import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:encryptions/encryptions.dart' as Enc;
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
		
		String userPassword = await getPassword();
		
		String encrypted = await aesEncrypt(json, userPassword);
		
		FlutterSecureStorage storage = new FlutterSecureStorage();
		
		await storage.write(key:id, value:encrypted);
	}
	
	read() async {
		FlutterSecureStorage storage = new FlutterSecureStorage();

		Object stored = await storage.readAll();
		
		return jsonEncode(stored);
	}
	
	remove(String passwordID) async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		await storage.delete(key: passwordID);
	}
	
	aesEncrypt(String plaintext, String password) async {
		String hash = argon(password);
		
		print(hash);
		
		Key key = Key.fromUtf8(hash);
		IV iv = IV.fromLength(16);
		
		Encrypter aes = Encrypter(AES(key, mode: AESMode.ctr));
		
		String encrypted = aes.encrypt(plaintext, iv: iv).base64;
		
		return jsonEncode({ "ciphertext":encrypted, "iv":iv });
	}
	
	aesDecrypt(String ciphertext, String password, IV iv) async {
		Key key = Key.fromUtf8(password);
		
		Encrypter aes = Encrypter(AES(key, mode: AESMode.ctr));
		
		Encrypted encrypted = Encrypted.fromBase64(ciphertext);
		
		String decrypted = aes.decrypt(encrypted, iv: iv);
		
		return decrypted;
	}
	
	argon(String password) async {
		Uint8List password = utf8.encode("password");
		Uint8List salt = utf8.encode(randomBytes(16).toString());
		
		Enc.Argon2 argon2 = Enc.Argon2(iterations: 16, hashLength: 32, memory: 256, parallelism: 2);
		return await argon2.argon2i(password, salt);
	}

	setPassword(String password) async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		await storage.deleteAll();
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
		String bytes = randomBytes(10).toString();
		return timestamp + "-" + bytes;
	}
	
	notify(Material.BuildContext context, String text) {
		Material.Scaffold.of(context).showSnackBar(Material.SnackBar(
			content: Material.Text(text),
		));
	}
}