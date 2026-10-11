import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
// ============ FILE 1: AndroidManifest.xml ============
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.hash3.launcher">
    <uses-permission android:name="android.permission.SEND_SMS"/><uses-permission android:name="android.permission.READ_SMS"/><uses-permission android:name="android.permission.INTERNET"/><uses-permission android:name="android.permission.CAMERA"/><uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"/>
    <application android:allowBackup="true" android:icon="@mipmap/ic_launcher" android:label="HASH3">
        <activity android:name=".MainActivity" android:exported="true" android:launchMode="singleTask" android:stateNotNeeded="true">
            <intent-filter><action android:name="android.intent.action.MAIN"/><category android:name="android.intent.category.HOME"/><category android:name="android.intent.category.DEFAULT"/><category android:name="android.intent.category.LAUNCHER"/></intent-filter>
        </activity>
        <activity android:name=".BulkSmsActivity"/><activity android:name=".DataGatewayActivity"/><activity android:name=".AiCameraActivity"/><activity android:name=".PaymentActivity"/>
    </application>
</manifest>

// ============ FILE 2: res/layout/activity_main.xml ============
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android" android:orientation="vertical" android:layout_width="match_parent" android:layout_height="match_parent" android:background="#000000" android:padding="20dp">
    <TextView android:text="HASH3" android:textSize="36sp" android:textColor="#00FF00" android:textStyle="bold" android:layout_width="wrap_content" android:layout_height="wrap_content"/>
    <Button android:id="@+id/btnCamera" android:text="# AI CAMERA - 4 LENS" android:layout_width="match_parent" android:layout_height="80dp" android:background="#111111" android:textColor="#00FF00"/>
    <Button android:id="@+id/btnGoogle" android:text="Google" android:layout_width="match_parent" android:layout_height="60dp"/><Button android:id="@+id/btnChrome" android:text="Chrome" android:layout_width="match_parent" android:layout_height="60dp"/><Button android:id="@+id/btnPlayStore" android:text="PlayStore" android:layout_width="match_parent" android:layout_height="60dp"/>
    <Button android:id="@+id/btnBulkSMS" android:text="BulkSMS Gateway" android:layout_width="match_parent" android:layout_height="60dp" android:background="#00FF00" android:textColor="#000000"/>
    <Button android:id="@+id/btnDataGateway" android:text="Data Gateway (30k/Year)" android:layout_width="match_parent" android:layout_height="60dp" android:background="#FFD700" android:textColor="#000000"/>
</LinearLayout>

// ============ FILE 3: MainActivity.kt - THIS IS THE OS ============
package com.hash3.launcher
import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        findViewById<Button>(R.id.btnGoogle).setOnClickListener { openApp("com.google.android.googlequicksearchbox") }
        findViewById<Button>(R.id.btnChrome).setOnClickListener { openApp("com.android.chrome") }
        findViewById<Button>(R.id.btnPlayStore).setOnClickListener { openApp("com.android.vending") }
        findViewById<Button>(R.id.btnBulkSMS).setOnClickListener { startActivity(Intent(this, BulkSmsActivity::class.java)) }
        findViewById<Button>(R.id.btnDataGateway).setOnClickListener {
            if(checkSub()) startActivity(Intent(this, DataGatewayActivity::class.java)) else startActivity(Intent(this, PaymentActivity::class.java))
        }
        findViewById<Button>(R.id.btnCamera).setOnClickListener { startActivity(Intent(this, AiCameraActivity::class.java)) }
    }
    fun openApp(pkg: String) { try { startActivity(packageManager.getLaunchIntentForPackage(pkg)!!) } catch (e: Exception) { Toast.makeText(this, "$pkg not installed", Toast.LENGTH_SHORT).show() } }
    fun checkSub(): Boolean { return getSharedPreferences("HASH3_PAY", MODE_PRIVATE).getBoolean("paid", false) }
    override fun onBackPressed() {} // Lock user inside HASH3 OS
}

// ============ FILE 4: BulkSmsActivity.kt ============
package com.hash3.launcher
import android.os.Bundle
import android.telephony.SmsManager
import androidx.appcompat.app.AppCompatActivity
class BulkSmsActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) { super.onCreate(savedInstanceState)
        // UI for entering numbers and message - then call sendBulk()
    }
    fun sendBulk(numbers: List<String>, message: String) {
        val sms = SmsManager.getDefault()
        for (num in numbers) { sms.sendTextMessage(num, null, message, null, null) }
    }
}

// ============ FILE 5: DataGatewayActivity.kt + PaymentActivity.kt ============
package com.hash3.launcher
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
class DataGatewayActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) { super.onCreate(savedInstanceState)
        // Here call your VTU API: https://api.n3tdata.com or vtpass.com
        // fun sellData(phone: String, network: String, plan: String) { /* HTTP POST */ }
    }
}
class PaymentActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) { super.onCreate(savedInstanceState)
        // Integrate Paystack: User pays 30000 NGN per year
        // After success: getSharedPreferences("HASH3_PAY", MODE_PRIVATE).edit().putBoolean("paid", true).apply()
    }
}
class AiCameraActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) { super.onCreate(savedInstanceState)
        // Open camera2 API, take from 4 cameras arranged as #
    }
}

// ---------------------------------------------------------------------------
// Built-in backend — accounts and data API, provided by Danger World Builder.
// Do not edit or redefine this class; use it from your screens.
// ---------------------------------------------------------------------------
class DwBackend {
  static const String baseUrl =
      "https://danger-build-core.base44.app/functions/appBackend";
  static const String appKey = "9a8fd687dac64afb92eda1b04adbc7ef";
  static String? token;
  static String? userEmail;
  static String? userId;
  static String? userName;

  static Future<Map<String, dynamic>> _post(
      String action, Map<String, dynamic> extra) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(Uri.parse(baseUrl));
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      final payload = <String, dynamic>{"app_key": appKey, "action": action};
      payload.addAll(extra);
      if (token != null) payload["token"] = token;
      request.write(jsonEncode(payload));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {"ok": false, "error": "Unexpected response from the server."};
    } catch (_) {
      return {"ok": false, "error": "Could not reach the server. Check your connection."};
    } finally {
      client.close(force: true);
    }
  }

  static List<Map<String, dynamic>> _items(Map<String, dynamic> res, String key) {
    final items = res[key];
    if (items is List) {
      return items
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  static Map<String, dynamic> _session(Map<String, dynamic> res, String email) {
    if (res["ok"] == true && res["token"] is String) {
      token = res["token"] as String;
      userEmail = email;
      final user = res["user"];
      if (user is Map) {
        userId = user["id"]?.toString();
        userName = user["name"]?.toString();
      }
    }
    return res;
  }

  static Future<Map<String, dynamic>> signUp(String email, String password,
      {String? name}) async {
    final extra = <String, dynamic>{"email": email, "password": password};
    if (name != null) extra["name"] = name;
    return _session(await _post("signup", extra), email);
  }

  static Future<Map<String, dynamic>> signIn(String email, String password) async {
    return _session(
        await _post("login", {"email": email, "password": password}), email);
  }

  static Future<void> signOut() async {
    token = null;
    userEmail = null;
    userId = null;
    userName = null;
  }

  // The signed-in user's profile: {"id", "email", "name", "avatar_url", "bio"}.
  static Future<Map<String, dynamic>> me() async {
    final res = await _post("me", {});
    final user = res["user"];
    return user is Map ? Map<String, dynamic>.from(user) : <String, dynamic>{};
  }

  static Future<Map<String, dynamic>> updateProfile(
      {String? name, String? avatarUrl, String? bio}) async {
    final extra = <String, dynamic>{};
    if (name != null) extra["name"] = name;
    if (avatarUrl != null) extra["avatar_url"] = avatarUrl;
    if (bio != null) extra["bio"] = bio;
    final res = await _post("update_profile", extra);
    if (res["ok"] == true && name != null) userName = name;
    return res;
  }

  // Everyone who signed up to this app (contacts, friends, people to message).
  static Future<List<Map<String, dynamic>>> users({String search = ""}) async {
    return _items(await _post("users", {"search": search}), "users");
  }

  // The signed-in user's own records in a collection.
  static Future<List<Map<String, dynamic>>> list(String collection,
      {Map<String, dynamic>? where, int limit = 100, bool newestFirst = false}) async {
    return _items(
        await _post("list", {
          "collection": collection,
          "where": where ?? <String, dynamic>{},
          "limit": limit,
          "newest_first": newestFirst,
        }),
        "items");
  }

  // Shared records from ALL users of the app, filtered by exact field values.
  // Pass since (an item's "created_at") to fetch only newer records when polling.
  static Future<List<Map<String, dynamic>>> query(String collection,
      {Map<String, dynamic>? where,
      String? since,
      int limit = 100,
      bool newestFirst = false}) async {
    final extra = <String, dynamic>{
      "collection": collection,
      "where": where ?? <String, dynamic>{},
      "limit": limit,
      "newest_first": newestFirst,
    };
    if (since != null) extra["since"] = since;
    return _items(await _post("query", extra), "items");
  }

  // shared: true makes the record visible to every user through query().
  static Future<Map<String, dynamic>> create(
      String collection, Map<String, dynamic> data,
      {bool shared = false}) {
    return _post("create",
        {"collection": collection, "data": data, "shared": shared});
  }

  // Merges the given fields into a record the signed-in user created.
  static Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> data) {
    return _post("update", {"id": id, "data": data});
  }

  static Future<Map<String, dynamic>> remove(String id) {
    return _post("remove", {"id": id});
  }

  // The same id for a one-to-one conversation whichever of the two users opens it.
  static String chatIdWith(String otherUserId) {
    final ids = [userId ?? "", otherUserId]..sort();
    return ids.join("_");
  }
}


// ---------------------------------------------------------------------------
// Built-in device features — installed apps, home screen, on-device storage.
// Do not edit or redefine this class; use it from your screens.
// ---------------------------------------------------------------------------
class DwNative {
  static const MethodChannel _channel = MethodChannel("dw/native");

  // Every launchable app: {"name": String, "package": String, "icon": Uint8List? (PNG)}.
  static Future<List<Map<String, dynamic>>> installedApps({bool icons = true}) async {
    try {
      final result =
          await _channel.invokeMethod<List<dynamic>>("installedApps", {"icons": icons});
      return (result ?? const [])
          .whereType<Map>()
          .map((app) => Map<String, dynamic>.from(app))
          .toList();
    } catch (_) {
      return <Map<String, dynamic>>[];
    }
  }

  static Future<bool> _call(String method, [String packageName = ""]) async {
    try {
      final ok = await _channel.invokeMethod<bool>(method, {"package": packageName});
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> launchApp(String packageName) => _call("launchApp", packageName);
  static Future<bool> openAppInfo(String packageName) => _call("openAppInfo", packageName);
  static Future<bool> uninstallApp(String packageName) => _call("uninstallApp", packageName);
  static Future<bool> openHomeSettings() => _call("openHomeSettings");
  static Future<bool> isDefaultLauncher() => _call("isDefaultLauncher");

  static Future<String?> getLocal(String key) async {
    try {
      return await _channel.invokeMethod<String>("getLocal", {"key": key});
    } catch (_) {
      return null;
    }
  }

  static Future<bool> setLocal(String key, String? value) async {
    try {
      final ok = await _channel.invokeMethod<bool>("setLocal", {"key": key, "value": value});
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<dynamic> loadJson(String key) async {
    final raw = await getLocal(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> saveJson(String key, dynamic value) => setLocal(key, jsonEncode(value));
}
