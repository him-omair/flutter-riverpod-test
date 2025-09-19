import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

enum City { mosul, tokyo, paris }

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {City.mosul: '☀', City.tokyo: '❄', City.paris: '🌫'}[city] ?? '?',
  );
}

final String unknownWeatherEmoji = '🤷‍♂️';

final cityProvider = StateProvider<City?>((ref) => null);

final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(cityProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return unknownWeatherEmoji;
  }
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Weather'), centerTitle: true),
        body: Center(
          child: Column(
            children: [
              currentWeather.when(
                data: (data) => Text(data, style: TextStyle(fontSize: 40)),
                error: (error, stackTrace) => Text('Error'),
                loading: () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: City.values.length,
                  itemBuilder: (context, index) {
                    final city = City.values[index];
                    final isSelected = city == ref.watch(cityProvider);
                    return ListTile(
                      title: Text(city.toString()),
                      trailing: isSelected ? Icon(Icons.check) : null,
                      onTap: () {
                        ref.read(cityProvider.notifier).state = city;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
