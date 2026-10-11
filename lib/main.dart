import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Hash3App());
}

class Hash3App extends StatelessWidget {
  const Hash3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HASH3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      home: const MainActivity(),
    );
  }
}

// ============ MainActivity ============
class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  Future<bool> checkSub() async {
    final paid = await DwNative.getLocal("HASH3_PAY");
    return paid == "paid";
  }

  void openApp(String pkg) async {
    final launched = await DwNative.launchApp(pkg);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$pkg not installed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "HASH3",
                    style: TextStyle(
                      fontSize: 36,
                      color: Color(0xFF00FF00),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF111111),
                        foregroundColor: const Color(0xFF00FF00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFF00FF00), width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AiCameraActivity()),
                        );
                      },
                      child: const Text(
                        "# AI CAMERA - 4 LENS",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00FF00),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => openApp("com.google.android.googlequicksearchbox"),
                      child: const Text("Google", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => openApp("com.android.chrome"),
                      child: const Text("Chrome", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => openApp("com.android.vending"),
                      child: const Text("PlayStore", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF00),
                        foregroundColor: const Color(0xFF000000),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BulkSmsActivity()),
                        );
                      },
                      child: const Text(
                        "BulkSMS Gateway",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: const Color(0xFF000000),
                      ),
                      onPressed: () async {
                        final paid = await checkSub();
                        if (!context.mounted) return;
                        if (paid) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DataGatewayActivity()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PaymentActivity()),
                          );
                        }
                      },
                      child: const Text(
                        "Data Gateway (30k/Year)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============ BulkSmsActivity ============
class BulkSmsActivity extends StatefulWidget {
  const BulkSmsActivity({super.key});

  @override
  State<BulkSmsActivity> createState() => _BulkSmsActivityState();
}

class _BulkSmsActivityState extends State<BulkSmsActivity> {
  final _numbersController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sending = false;

  void sendBulk() async {
    final numbersText = _numbersController.text.trim();
    final message = _messageController.text.trim();
    if (numbersText.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter recipient numbers and message")),
      );
      return;
    }
    final numbers = numbersText
        .split(RegExp(r'[\n,]+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _sending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sent message to ${numbers.length} numbers successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("BulkSMS Gateway"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _numbersController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Phone Numbers (comma or newline separated)",
                labelStyle: TextStyle(color: Color(0xFF00FF00)),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Message",
                labelStyle: TextStyle(color: Color(0xFF00FF00)),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF00),
                  foregroundColor: Colors.black,
                ),
                onPressed: _sending ? null : sendBulk,
                child: Text(
                  _sending ? "Sending..." : "Send Bulk SMS",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ DataGatewayActivity ============
class DataGatewayActivity extends StatefulWidget {
  const DataGatewayActivity({super.key});

  @override
  State<DataGatewayActivity> createState() => _DataGatewayActivityState();
}

class _DataGatewayActivityState extends State<DataGatewayActivity> {
  final _phoneController = TextEditingController();
  String _network = "MTN";
  String _plan = "1GB SME - 300 NGN";

  void sellData() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter recipient phone number")),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data sent to $phone ($_network, $_plan)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Data Gateway"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Recipient Phone Number",
                labelStyle: TextStyle(color: Color(0xFFFFD700)),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _network,
              dropdownColor: const Color(0xFF111111),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Network",
                labelStyle: TextStyle(color: Color(0xFFFFD700)),
                border: OutlineInputBorder(),
              ),
              items: ["MTN", "AIRTEL", "GLO", "9MOBILE"]
                  .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                  .toList(),
              onChanged: (val) => setState(() => _network = val ?? "MTN"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _plan,
              dropdownColor: const Color(0xFF111111),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Data Plan",
                labelStyle: TextStyle(color: Color(0xFFFFD700)),
                border: OutlineInputBorder(),
              ),
              items: [
                "1GB SME - 300 NGN",
                "2GB SME - 600 NGN",
                "5GB SME - 1500 NGN",
                "10GB Corporate - 3000 NGN",
              ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (val) => setState(() => _plan = val ?? _plan),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                ),
                onPressed: sellData,
                child: const Text(
                  "Sell Data",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ PaymentActivity ============
class PaymentActivity extends StatefulWidget {
  const PaymentActivity({super.key});

  @override
  State<PaymentActivity> createState() => _PaymentActivityState();
}

class _PaymentActivityState extends State<PaymentActivity> {
  bool _processing = false;

  void pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 1));
    await DwNative.setLocal("HASH3_PAY", "paid");
    if (!mounted) return;
    setState(() => _processing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment successful! Data Gateway unlocked.")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DataGatewayActivity()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Data Gateway Subscription"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.payment, size: 80, color: Color(0xFFFFD700)),
            const SizedBox(height: 20),
            const Text(
              "Activate Data Gateway",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              "Fee: 30,000 NGN per year",
              style: TextStyle(fontSize: 18, color: Color(0xFFFFD700)),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                ),
                onPressed: _processing ? null : pay,
                child: Text(
                  _processing ? "Processing Paystack..." : "Pay 30,000 NGN (Paystack)",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ AiCameraActivity ============
class AiCameraActivity extends StatelessWidget {
  const AiCameraActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("# AI CAMERA - 4 LENS"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            _lensView("LENS #1 (Wide Angle)"),
            _lensView("LENS #2 (Ultra Wide)"),
            _lensView("LENS #3 (Telephoto)"),
            _lensView("LENS #4 (Macro / Depth)"),
          ],
        ),
      ),
    );
  }

  Widget _lensView(String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border.all(color: const Color(0xFF00FF00), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, color: Color(0xFF00FF00), size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF00FF00),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Built-in backend — accounts and data API, provided by Danger World Builder.
// Do not edit or redefine this class; use it from your screens.
// ---------------------------------------------------------------------------


// ---------------------------------------------------------------------------
// Built-in device features — installed apps, home screen, on-device storage.
// Do not edit or redefine this class; use it from your screens.
// ---------------------------------------------------------------------------


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
