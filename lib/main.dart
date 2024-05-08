import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ScrollableFibonacciList(),
    );
  }
}

class ScrollableFibonacciList extends StatefulWidget {
  @override
  State<ScrollableFibonacciList> createState() =>
      _ScrollableFibonacciListState();
}

class _ScrollableFibonacciListState extends State<ScrollableFibonacciList> {
  final int numFibonacci = 40;
  FibonacciItem? clickNumber;

  final List<FibonacciItem> _list = [];
  final List<FibonacciItem> circleList = [];
  final List<FibonacciItem> crossList = [];
  final List<FibonacciItem> squareList = [];
  final scrollController = ScrollController();

  @override
  void initState() {
    int index = 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      do {
        _list.add(FibonacciItem(
          fibonacci(index),
          generateIcon(),
          index,
        ));
        index++;
      } while (index < numFibonacci);
      setState(() {});
    });
    super.initState();
  }

  int generateIcon() {
    return Random().nextInt(3);
  }

  Icon getIcon(int type) {
    switch (type) {
      case 0:
        return const Icon(Icons.circle);
      case 1:
        return const Icon(Icons.close);
      case 2:
        return const Icon(Icons.square_outlined);
      default:
        return const Icon(Icons.circle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('7 Solutions Test'),
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: clickNumber != null
                  ? clickNumber!.index == _list[index].index
                      ? Colors.red
                      : Colors.white
                  : Colors.white,
            ),
            child: ListTile(
              onTap: () => clickItem(_list[index]),
              title: Text(
                "Index: ${_list[index].index}, Number : ${_list[index].number}",
                style: const TextStyle(fontSize: 18.0),
              ),
              trailing: getIcon(
                _list[index].type,
              ),
            ),
          );
        },
      ),
    );
  }

  void clickItem(
    FibonacciItem fibonacciItem,
  ) {
    clickNumber = null;
    switch (fibonacciItem.type) {
      case 0:
        if (!circleList.contains(fibonacciItem)) circleList.add(fibonacciItem);
        break;
      case 1:
        if (!crossList.contains(fibonacciItem)) crossList.add(fibonacciItem);
        break;
      case 2:
        if (!squareList.contains(fibonacciItem)) squareList.add(fibonacciItem);
        break;
    }
    _list.remove(fibonacciItem);
    setState(() {});
    List<FibonacciItem> selectedList = [];
    switch (fibonacciItem.type) {
      case 0:
        selectedList = circleList;
        break;
      case 1:
        selectedList = crossList;
        break;
      case 2:
        selectedList = squareList;
        break;
    }
    showBottomSheetDialog(
      context,
      fibonacciItem.index,
      selectedList,
    );
  }

  int fibonacci(int n) {
    if (n == 0) return 0;
    if (n == 1) return 1;
    int a = 0;
    int b = 1;
    int c;
    for (int i = 2; i <= n; i++) {
      c = a + b;
      a = b;
      b = c;
    }
    return b;
  }

  void showBottomSheetDialog(
    BuildContext context,
    int selectedIndex,
    List<FibonacciItem> list,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Container(
                color: selectedIndex == list[index].index
                    ? Colors.green
                    : Colors.white,
                child: ListTile(
                  onTap: () => showOtherNumber(
                    list[index],
                    context,
                  ),
                  title: Text("Number ${list[index].number}"),
                  subtitle: Text("Index ${list[index].index}"),
                  trailing: getIcon(list[index].type),
                ),
              );
            },
          ),
        );
      },
    );
  }

  showOtherNumber(FibonacciItem fibonacciItem, BuildContext context) {
    _list.add(fibonacciItem);
    _list.sort((a, b) => a.number.compareTo(b.number));
    switch (fibonacciItem.type) {
      case 0:
        circleList.remove(fibonacciItem);
        break;
      case 1:
        crossList.remove(fibonacciItem);
        break;
      case 2:
        squareList.remove(fibonacciItem);
        break;
    }
    final item =
        _list.firstWhere((element) => element.number == fibonacciItem.number);
    scrollController.animateTo(
      item.index * 30,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    clickNumber = fibonacciItem;

    setState(() {});
    Navigator.pop(context);
  }
}

class FibonacciItem {
  int number;
  int type;
  int index;

  FibonacciItem(
    this.number,
    this.type,
    this.index,
  );
}
