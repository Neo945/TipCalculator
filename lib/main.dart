import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
      ),
      home: MyHomePage(title: 'Tip Me'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currency = {"USD": "\$"};
  int _counter = 0;
  bool _valid = true;
  String _curr = 'USD';
  late final TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Text(
                  'TipMe',
                  style: TextStyle(fontSize: 100),
                ),
                SizedBox(
                  height: 100,
                ),
                Row(children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: DropdownButton<String>(
                      value: currency.keys.toList()[0],
                      onChanged: (String? s) {
                        setState(() {
                          this._curr = s!;
                        });
                      },
                      items: currency.keys
                          .toList()
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 10,
                    child: TextField(
                      onChanged: (var s) {
                        setState(() {
                          this._valid = true;
                        });
                      },
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        errorText: (!_valid) ? 'Please enter the amount' : null,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        prefix: Text('${currency[this._curr]}  '),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'Enter the Amount',
                      ),
                    ),
                  )
                ]),
                SizedBox(
                  height: 20,
                ),
                Slider(
                  onChanged: (double value) {
                    setState(() {
                      _counter = value.round();
                    });
                  },
                  value: _counter.toDouble(),
                  min: 0,
                  max: 10,
                  label: '$_counter',
                  divisions: 10,
                ),
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (controller.text == '') {
                        setState(() {
                          this._valid = false;
                        });
                        return;
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SecondPage(
                          curr: currency[this._curr]!,
                          total: double.parse(controller.text),
                          amount: (_counter * int.parse(controller.text) / 100),
                        ),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                    ),
                    child: Text('Calculate')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage(
      {Key? key, required this.amount, required this.total, required this.curr})
      : super(key: key);

  final double amount;
  final String curr;
  final double total;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total: ${widget.curr} ${widget.total}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Tip: ${widget.curr} ${widget.amount}',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      )),
    );
  }
}
