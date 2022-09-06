import 'package:flutter/material.dart';

class UtilitiesView extends StatefulWidget {
  const UtilitiesView({Key? key}) : super(key: key);

  @override
  State<UtilitiesView> createState() => _UtilitiesViewState();
}

class _UtilitiesViewState extends State<UtilitiesView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Utilities',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        children: [],
      ),
    );
  }
}
