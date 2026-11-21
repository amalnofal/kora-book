import 'package:material_ui/material_ui.dart';

class KoraBookApp extends StatelessWidget {
  const KoraBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Kora Book',
      home: Scaffold(body: Center(child: Text('Kora Book'))),
    );
  }
}
