import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_veeda/providers/auth_provider.dart';
import 'package:task_manager_veeda/providers/task_provider.dart';
import 'package:task_manager_veeda/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, TaskProvider>(
          create: (ctx) => TaskProvider(),
          update: (ctx, auth, previousTasks) => previousTasks!..update(auth),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager Veeda',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            secondary: Colors.blueAccent,
            error: Colors.red,
          ),
        ),
        // Go directly to the HomeScreen, bypassing authentication
        home: HomeScreen(),
      ),
    );
  }
}