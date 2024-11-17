import 'package:expense_tracker/app_router.dart';
import 'package:expense_tracker/core/services/injection_container.dart';
import 'package:expense_tracker/features/expense/presentation/cubit/expense_cubit.dart';
import 'package:expense_tracker/features/expense/presentation/view_all_expenses_page.dart';
import 'package:expense_tracker/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: GlobalThemeData.lightThemeData,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: "/",
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint("currentIndex is at index: $_currentIndex");
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          BlocProvider(
            create: (context) => serviceLocator<ExpenseCubit>(),
            child: const ViewAllExpensesPage(),
          ),
          const Center(
            child: Text('Insert Budget Page here'),
          ),
          const Center(
            child: Text('Insert User Profile Page here'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // stateful widget
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
