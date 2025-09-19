import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

final getDate = Provider((ref) => DateTime.now());

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(getDate);
    return Scaffold(
      appBar: AppBar(title: Text('Demo'), centerTitle: true),
      body: Center(child: Text(now.toString())),
    );
  }
}
