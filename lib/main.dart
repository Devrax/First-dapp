import "package:flutter/material.dart";
import "package:hello_world/contract_linking.dart";
import "package:provider/provider.dart";
import "package:hello_world/helloUI.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContractLinking>(
      create: (_) => ContractLinking(),
      child: MaterialApp(
        title: "Hello World",
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.cyan[400],
          accentColor: Colors.deepOrange[200]),
        home: HelloUI()
        )
      )
  }

}
