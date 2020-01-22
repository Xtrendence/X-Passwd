import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_hash/password_hash.dart';
import 'package:password_hash/pbkdf2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';
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
		
		Map<String, dynamic> stored = await storage.readAll();
		
		stored.remove("password");
		
		List ids = stored.keys.toList();
		
		for(int i = 0; i < ids.length; i++) {
			String id = ids[i];
			
			Map<String, dynamic> item = jsonDecode(stored[id]);
			
			String ciphertext = item["ciphertext"];
			IV iv = IV.fromBase64(item["iv"]);
			String salt = item["salt"];
			
			String hash = await pbkdf2WithSalt(await getPassword(), salt);
			
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
		Map<String, dynamic> argonHash = await pbkdf2(password);
		String hash = argonHash["hash"];
		
		Key key = Key.fromUtf8(hash);
		IV iv = IV.fromBase64(base64.encode(randomBytes(16)));
		
		Encrypter aes = Encrypter(AES(key, mode: AESMode.ctr));
		
		String encrypted = aes.encrypt(plaintext, iv: iv).base64;
		
		return jsonEncode({ "ciphertext":encrypted, "iv":iv.base64, "salt":argonHash["salt"] });
	}
	
	aesDecrypt(String ciphertext, String hash, IV iv) async {
		Key key = Key.fromUtf8(hash);
		
		Encrypter aes = Encrypter(AES(key, mode: AESMode.ctr));
		
		Encrypted encrypted = Encrypted.fromBase64(ciphertext);
		
		String decrypted = aes.decrypt(encrypted, iv: iv);
		
		return decrypted;
	}
	
	pbkdf2(String password) async {
		PBKDF2 generator = new PBKDF2();
		String salt = Salt.generateAsBase64String(32);
		String hash = generator.generateBase64Key(password, salt, 12000, 22);
		
		Map<String, dynamic> result = { "hash":hash, "salt":salt };
		
		return result;
	}
	
	pbkdf2WithSalt(String password, String salt) async {
		PBKDF2 generator = new PBKDF2();
		String hash = generator.generateBase64Key(password, salt, 12000, 22);
		return hash;
	}
	
	setPassword(String password) async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		await storage.deleteAll();
		await storage.write(key: "password", value: password);
	}
	
	changePassword(String newPassword) async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		
		String currentPassword = await getPassword();
		
		Map<String, dynamic> currentVault = await storage.readAll();
		
		bool valid = true;
		
		try {
			Map<String, dynamic> vault = await storage.readAll();
			
			await vault.remove("password");
			
			List keys = vault.keys.toList();
			
			for(int i = 0; i < keys.length; i++) {
				String id = keys[i];
				
				if(id != "password") {
					Map<String, dynamic> item = jsonDecode(vault[id]);
					String ciphertext = item["ciphertext"];
					IV iv = IV.fromBase64(item["iv"]);
					String salt = item["salt"];
					
					String hash = await pbkdf2WithSalt(currentPassword, salt);
					String plaintext = await aesDecrypt(ciphertext, hash, iv);
					
					String encrypted = await aesEncrypt(plaintext, newPassword);
					
					Map<String, dynamic> newItem = jsonDecode(encrypted);
					String newCiphertext = newItem["ciphertext"];
					IV newIV = IV.fromBase64(newItem["iv"]);
					String newSalt = newItem["salt"];
					
					String newHash = await pbkdf2WithSalt(newPassword, newSalt);
					
					if(await aesCheck(ciphertext, hash, iv) && await aesCheck(newCiphertext, newHash, newIV)) {
						await storage.write(key: id, value: encrypted);
					}
					else {
						valid = false;
					}
				}
			}
		}
		catch(e) {
			valid = false;
			print(e);
		}
		
		if(!valid) {
			restoreVault(currentVault);
		}
		else {
			await storage.delete(key: "password");
			await storage.write(key: "password", value: newPassword);
		}
		
		return valid;
	}
	
	exportVault() async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		
		Map<String, dynamic> stored = await storage.readAll();
		
		stored.remove("password");
		
		String filePath = (await getExternalStorageDirectory()).path + new DateTime.now().millisecondsSinceEpoch.toString() + ".passwd";
		
		File file = File(filePath);
		
		await file.writeAsString(jsonEncode(stored));
		
		return filePath;
	}
	
	importVault(String vault, String password) async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		Map<String, dynamic> currentVault = await storage.readAll();
		await storage.deleteAll();
		
		bool valid = true;
		
		try {
			Map<String, dynamic> encryptedItems = jsonDecode(vault);
			List ids = encryptedItems.keys.toList();
			
			for(int i = 0; i < ids.length; i++) {
				String key = ids[i];
				Map<String, dynamic> value = jsonDecode(encryptedItems[key]);
				if(value.containsKey("ciphertext") && value.containsKey("iv") && value.containsKey("salt")) {
					try {
						String ciphertext = value["ciphertext"];
						IV iv = IV.fromBase64(value["iv"]);
						String salt = value["salt"];
						String hash = await pbkdf2WithSalt(password, salt);
						
						Map<String, dynamic> item = jsonDecode(await aesDecrypt(ciphertext, hash, iv));
						
						if(item.containsKey("title") && item.containsKey("url") && item.containsKey("password") && item.containsKey("notes")) {
							await storage.write(key: key, value: jsonEncode(value));
						}
						else {
							valid = false;
						}
					}
					catch(e) {
						valid = false;
					}
				}
				else {
					valid = false;
				}
			}
			
			if(!valid) {
				await restoreVault(currentVault);
			}
			else {
				await storage.write(key: "password", value: password);
			}
		}
		catch(e) {
			await restoreVault(currentVault);
		}
		
		return valid;
	}
	
	aesCheck(String ciphertext, String password, IV iv) async {
		bool valid = true;
		try {
			aesDecrypt(ciphertext, password, iv);
		}
		catch(e) {
			valid = false;
		}
		return valid;
	}
	
	restoreVault(Map currentVault) async {
		FlutterSecureStorage storage = new FlutterSecureStorage();
		await storage.deleteAll();
		List keys = currentVault.keys.toList();
		for(int i = 0; i < keys.length; i++) {
			String key = keys[i];
			String value = currentVault[keys[i]];
			await storage.write(key: key, value: value);
		}
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
		Map<String, dynamic> values = await storage.readAll();
		if(values.keys.length > 0) {
			return true;
		}
		return false;
	}
	
	generatePassword() async {
		Random firstSeed = Random.secure();
		Random secondSeed = Random.secure();
		Random thirdSeed = Random.secure();
		String password = randomString(6, provider: CoreRandomProvider.from(firstSeed)) + randomString(6, provider: CoreRandomProvider.from(secondSeed)) + randomString(8, provider: CoreRandomProvider.from(thirdSeed));
		return password;
	}
	
	generateID() {
		String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
		String bytes = base64.encode(randomBytes(10));
		return timestamp + "-" + bytes;
	}
	
	notify(Material.BuildContext context, String text, int delay) {
		Material.Scaffold.of(context).showSnackBar(Material.SnackBar(
			content: Material.Text(text), duration: Duration(milliseconds: delay),
		));
	}
}