import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0); // initial state = 0
  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}

class IncrementStatusNotifier extends StateNotifier<bool> {
  IncrementStatusNotifier() : super(true);
  void reverseStatus() {
    state = !state;
  }
}

final statusProvider = StateNotifierProvider<IncrementStatusNotifier, bool>(
  (ref) => IncrementStatusNotifier(),
);

final StateNotifierProvider<CounterNotifier, int> counterProvider =
    StateNotifierProvider<CounterNotifier, int>((ref) {
      return CounterNotifier();
    });

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CounterPage());
  }
}

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Bounce Counter')),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);
            return Text('$count', style: const TextStyle(fontSize: 48));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final status = ref.read(statusProvider);
          if (status) {
            ref.read(counterProvider.notifier).increment();
          } else {
            ref.read(counterProvider.notifier).decrement();
          }
          final num = ref.read(counterProvider);
          if (num >= 9 || num <= 0) {
            ref.read(statusProvider.notifier).reverseStatus();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
