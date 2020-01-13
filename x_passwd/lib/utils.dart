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
		
		Map<String, dynamic> content = { "title":title, "url":url, "password":password, "notes":notes };
		
		String json = jsonEncode(content);
		
		String userPassword = await getPassword();
		
		String encrypted = await aesEncrypt(json, userPassword);
		
		FlutterSecureStorage storage = new FlutterSecureStorage();
		
		await storage.write(key:id, value:encrypted);
	}
	
	read() async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		
		Map<String, String> stored = await storage.readAll();
		
		stored.remove("password");
		
		List ids = stored.keys.toList();
		
		for(int i = 0; i < ids.length; i++) {
			String id = ids[i];
			
			Map<String, dynamic> item = jsonDecode(stored[id]);
			
			String ciphertext = item["ciphertext"];
			IV iv = IV.fromBase64(item["iv"]);
			Uint8List salt = base64.decode(item["salt"]);
			
			String hash = await argonWithSalt(await getPassword(), salt);
			
			String plaintext = await aesDecrypt(ciphertext, hash, iv);
			
			stored[id] = plaintext;
		}
		
		try {
			var sort = stored.entries.toList()
				..sort((item1, item2
					) {
					var difference = item1.value.compareTo(item2.value);
					if(difference == 0) {
						difference = item1.key.compareTo(item2.key);
					}
					return difference;
				});
			
			Map<String, dynamic> sorted = Map.fromEntries(sort);
			
			return jsonEncode(sorted);
		}
		catch(e) {
			return jsonEncode(stored);
		}
	}
	
	edit(String id, String title, String url, String password, String notes) async {
		Map<String, dynamic> content = { "title":title, "url":url, "password":password, "notes":notes };
		
		String json = jsonEncode(content);
		
		String userPassword = await getPassword();
		
		String encrypted = await aesEncrypt(json, userPassword);
		
		FlutterSecureStorage storage = new FlutterSecureStorage();
		
		await storage.write(key:id, value:encrypted);
	}
	
	remove(String passwordID) async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		await storage.delete(key: passwordID);
	}
	
	aesEncrypt(String plaintext, String password) async {
		Map<String, dynamic> argonHash = await argon(password);
		String hash = argonHash["hash"];
		
		Key key = Key.fromUtf8(hash);
		IV iv = IV.fromBase64(base64.encode(randomBytes(16)));
		
		Encrypter aes = Encrypter(AES(key, mode: AESMode.ctr));
		
		String encrypted = aes.encrypt(plaintext, iv: iv).base64;
		
		return jsonEncode({ "ciphertext":encrypted, "iv":iv.base64, "salt":argonHash["salt"] });
	}
	
	aesDecrypt(String ciphertext, String password, IV iv) async {
		Key key = Key.fromUtf8(password);
		
		Encrypter aes = Encrypter(AES(key, mode: AESMode.ctr));
		
		Encrypted encrypted = Encrypted.fromBase64(ciphertext);
		
		String decrypted = aes.decrypt(encrypted, iv: iv);
		
		return decrypted;
	}
	
	argon(String password) async {
		Uint8List pass = utf8.encode(password);
		
		Uint8List salt = utf8.encode(base64.encode(randomBytes(16)));
		
		Enc.Argon2 argon2 = Enc.Argon2(iterations: 16, hashLength: 22, memory: 256, parallelism: 2);
		
		String hash = base64.encode(await argon2.argon2id(pass, salt));
		
		Map<String, String> result = { "hash":hash, "salt":base64.encode(salt) };
		
		return result;
	}
	
	argonWithSalt(String password, Uint8List salt) async {
		Uint8List pass = utf8.encode(password);
		
		Enc.Argon2 argon2 = Enc.Argon2(iterations: 16, hashLength: 22, memory: 256, parallelism: 2);
		
		String hash = base64.encode(await argon2.argon2id(pass, salt));
		
		return hash;
	}
	
	setPassword(String password) async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		await storage.deleteAll();
		await storage.write(key:"password", value:password);
	}
	
	changePassword(String password) async {
	
	}
	
	exportVault() async {
	
	}
	
	importVault(String exportedVault) {
	
	}
	
	deleteVault() async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		await storage.deleteAll();
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
		String bytes = base64.encode(randomBytes(10));
		return timestamp + "-" + bytes;
	}
	
	notify(Material.BuildContext context, String text) {
		Material.Scaffold.of(context).showSnackBar(Material.SnackBar(
			content: Material.Text(text),
		));
	}
}