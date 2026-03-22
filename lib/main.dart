import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:ecommerce_admin_app/firebase_options.dart';
import 'package:ecommerce_admin_app/providers/admin_provider.dart';
import 'package:ecommerce_admin_app/views/admin_home.dart';
import 'package:ecommerce_admin_app/views/categories_page.dart';
import 'package:ecommerce_admin_app/views/coupons.dart';
import 'package:ecommerce_admin_app/views/login.dart';
import 'package:ecommerce_admin_app/views/modify_product.dart';
import 'package:ecommerce_admin_app/views/modify_promo.dart';
import 'package:ecommerce_admin_app/views/orders_page.dart';
import 'package:ecommerce_admin_app/views/products_page.dart';
import 'package:ecommerce_admin_app/views/promo_banners_page.dart';
import 'package:ecommerce_admin_app/views/signup.dart';
import 'package:ecommerce_admin_app/views/view_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Firebase Initialize (Safely)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    // 2. Load .env file (Try-catch ke sath taaki app crash na ho)
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint("⚠️ .env file nahi mili. App chal raha hai.");
    }

    // Agar sab theek raha, toh app chalega
    runApp(const MyApp());
    
  } catch (e) {
    // 🔥 Black screen ki jagah red error text dikhega
    debugPrint("App Initialization Error: $e");
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Admin App Start Error:\n\n$e",
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminProvider(),
      builder: (context, child) => MaterialApp(
        title: 'Ecommerce Admin App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          "/": (context) => const CheckUser(),
          "/login": (context) => const LoginPage(),
          "/signup": (context) => const SingupPage(),
          "/home": (context) => const AdminHome(),
          "/category": (context) => const CategoriesPage(),
          "/products": (context) => const ProductsPage(),
          "/add_product": (context) => const ModifyProduct(),
          "/view_product": (context) => const ViewProduct(),
          "/promos": (context) => const PromoBannersPage(),
          "/update_promo": (context) => const ModifyPromo(),
          "/coupons": (context) => const CouponsPage(),
          "/orders": (context) => const OrdersPage(),
          "/view_order": (context) => const ViewOrder()
        },
      ),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    bool isLoggedIn = await AuthService().isLoggedIn();
    // mounted check zaroori hai error se bachne ke liye
    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
