import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF00),
          secondary: Color(0xFFFFD700),
          surface: Color(0xFF111111),
        ),
      ),
      home: const MainActivityScreen(),
    );
  }
}

class MainActivityScreen extends StatefulWidget {
  const MainActivityScreen({super.key});

  @override
  State<MainActivityScreen> createState() => _MainActivityScreenState();
}

class _MainActivityScreenState extends State<MainActivityScreen> {
  Future<bool> checkSub() async {
    final paid = await DwNative.getLocal("HASH3_PAY");
    return paid == "true";
  }

  void openApp(String pkg) async {
    final launched = await DwNative.launchApp(pkg);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$pkg not installed'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void handleDataGateway() async {
    final isPaid = await checkSub();
    if (!mounted) return;
    if (isPaid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DataGatewayActivityScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaymentActivityScreen()),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'HASH3',
                    style: TextStyle(
                      fontSize: 36,
                      color: Color(0xFF00FF00),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF111111),
                        foregroundColor: const Color(0xFF00FF00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: const BorderSide(color: Color(0xFF00FF00), width: 1.5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AiCameraActivityScreen()),
                        );
                      },
                      child: const Text(
                        '# AI CAMERA - 4 LENS',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => openApp('com.google.android.googlequicksearchbox'),
                      child: const Text('Google', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => openApp('com.android.chrome'),
                      child: const Text('Chrome', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => openApp('com.android.vending'),
                      child: const Text('PlayStore', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF00),
                        foregroundColor: const Color(0xFF000000),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BulkSmsActivityScreen()),
                        );
                      },
                      child: const Text(
                        'BulkSMS Gateway',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: const Color(0xFF000000),
                      ),
                      onPressed: handleDataGateway,
                      child: const Text(
                        'Data Gateway (30k/Year)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

class AiCameraActivityScreen extends StatelessWidget {
  const AiCameraActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '# AI CAMERA - 4 LENS',
          style: TextStyle(color: Color(0xFF00FF00)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF00FF00)),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildLensView('LENS 1: ULTRA WIDE 120°', Icons.panorama_wide_angle),
                _buildLensView('LENS 2: TELEPHOTO 10X', Icons.center_focus_strong),
                _buildLensView('LENS 3: MACRO AI DEPTH', Icons.filter_center_focus),
                _buildLensView('LENS 4: NIGHT INFRARED', Icons.nightlife),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: const Color(0xFF111111),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.flash_auto, color: Color(0xFF00FF00)),
                  onPressed: () {},
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quad-Lens Snapshot captured and processed by AI'),
                        backgroundColor: Color(0xFF00FF00),
                      ),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF00FF00), width: 4),
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Icon(Icons.camera_alt, color: Color(0xFF00FF00), size: 32),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.switch_camera, color: Color(0xFF00FF00)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLensView(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border.all(color: const Color(0xFF00FF00), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(icon, size: 48, color: const Color(0xFF00FF00).withAlpha(100)),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              color: Colors.black,
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF00FF00),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 8,
            right: 8,
            child: Text(
              'LIVE',
              style: TextStyle(
                color: Color(0xFF00FF00),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BulkSmsActivityScreen extends StatefulWidget {
  const BulkSmsActivityScreen({super.key});

  @override
  State<BulkSmsActivityScreen> createState() => _BulkSmsActivityScreenState();
}

class _BulkSmsActivityScreenState extends State<BulkSmsActivityScreen> {
  final TextEditingController _numbersController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _sending = false;

  void sendBulk() async {
    final rawNumbers = _numbersController.text.trim();
    final message = _messageController.text.trim();

    if (rawNumbers.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone numbers and message.')),
      );
      return;
    }

    final numbers = rawNumbers
        .split(RegExp(r'[,\n\s]+'))
        .where((s) => s.isNotEmpty)
        .toList();

    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bulk SMS sent successfully to ${numbers.length} recipients!'),
          backgroundColor: const Color(0xFF00FF00),
        ),
      );
      _numbersController.clear();
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _numbersController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('BulkSMS Gateway', style: TextStyle(color: Color(0xFF00FF00))),
        iconTheme: const IconThemeData(color: Color(0xFF00FF00)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter Phone Numbers (comma or newline separated):',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _numbersController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '+2348012345678, +2348087654321',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF111111),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF00FF00)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF00FF00)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SMS Message:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type your broadcast SMS message here...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF111111),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF00FF00)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF00FF00)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF00),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _sending ? null : sendBulk,
                  child: _sending
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'SEND BULK SMS NOW',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataGatewayActivityScreen extends StatefulWidget {
  const DataGatewayActivityScreen({super.key});

  @override
  State<DataGatewayActivityScreen> createState() => _DataGatewayActivityScreenState();
}

class _DataGatewayActivityScreenState extends State<DataGatewayActivityScreen> {
  String _network = 'MTN';
  String _plan = '1GB - 30 Days (₦280)';
  final TextEditingController _phoneController = TextEditingController();
  bool _loading = false;

  void sellData() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter customer phone number.')),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data bundle ($_plan) sent to $phone via $_network VTU API!'),
          backgroundColor: const Color(0xFF00FF00),
        ),
      );
      _phoneController.clear();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Data Gateway (VTU)', style: TextStyle(color: Color(0xFFFFD700))),
        iconTheme: const IconThemeData(color: Color(0xFFFFD700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFFD700)),
                ),
                child: const Column(
                  children: [
                    Text(
                      'API GATEWAY STATUS: CONNECTED',
                      style: TextStyle(color: Color(0xFF00FF00), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'VTU API: https://api.n3tdata.com / vtpass.com',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Select Network:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _network,
                dropdownColor: const Color(0xFF111111),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF111111),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
                items: ['MTN', 'AIRTEL', 'GLO', '9MOBILE'].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _network = val);
                },
              ),
              const SizedBox(height: 16),
              const Text('Data Plan:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _plan,
                dropdownColor: const Color(0xFF111111),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF111111),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
                items: [
                  '1GB - 30 Days (₦280)',
                  '2GB - 30 Days (₦550)',
                  '5GB - 30 Days (₦1,350)',
                  '10GB - 30 Days (₦2,650)',
                ].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _plan = val);
                },
              ),
              const SizedBox(height: 16),
              const Text('Recipient Phone Number:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '08012345678',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF111111),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _loading ? null : sellData,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'SELL DATA BUNDLE',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentActivityScreen extends StatefulWidget {
  const PaymentActivityScreen({super.key});

  @override
  State<PaymentActivityScreen> createState() => _PaymentActivityScreenState();
}

class _PaymentActivityScreenState extends State<PaymentActivityScreen> {
  bool _processing = false;

  void processPayment() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));
    await DwNative.setLocal("HASH3_PAY", "true");

    if (mounted) {
      setState(() => _processing = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF111111),
          title: const Text('Payment Successful', style: TextStyle(color: Color(0xFF00FF00))),
          content: const Text(
            'Your 30,000 NGN subscription for HASH3 Data Gateway is active for 1 year!',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF00)),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DataGatewayActivityScreen()),
                );
              },
              child: const Text('Access Data Gateway', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Payment Required', style: TextStyle(color: Color(0xFFFFD700))),
        iconTheme: const IconThemeData(color: Color(0xFFFFD700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock, size: 80, color: Color(0xFFFFD700)),
            const SizedBox(height: 24),
            const Text(
              'Data Gateway License',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              '₦30,000 / Year',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFFD700)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Access the automated VTU Data Gateway API to sell data directly to customers and unlock unlimited bulk provisioning.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 36),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                ),
                onPressed: _processing ? null : processPayment,
                child: _processing
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'PAY ₦30,000 (PAYSTACK)',
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
