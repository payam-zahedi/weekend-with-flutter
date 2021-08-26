import 'package:flutter/material.dart';
import 'package:weekend_with_flutter/src/widget/spinner.dart';

void main() {
  runApp(MyApp());
}

final showCases = [
  TileModel(title: 'Spinner Widget', child: Spinner(color: Colors.blue))
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#WeekendWithFlutter Challenge'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: showCases.length,
        itemBuilder: (BuildContext context, int index) {
          final item = showCases[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Text('${index + 1}', style: Theme.of(context).textTheme.headline6,),
              title: Text(
                item.title,
              ),
              tileColor: Theme
                  .of(context)
                  .colorScheme
                  .surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ScreenContainer(
                          title: item.title,
                          child: item.child,
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ScreenContainer extends StatelessWidget {
  const ScreenContainer({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: child),
    );
  }
}

class TileModel {
  const TileModel({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;
}
