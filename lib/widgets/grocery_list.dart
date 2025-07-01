import 'package:flutter/material.dart';

import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {

  final _groceryList = [];

  void _addItem() async{
    final newItem = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewItem()));
    if (newItem == null){
      return;
    }
    setState(() {
      _groceryList.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget activeWidget = ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryList[index].id),
          onDismissed: (direction) {
            setState(() {
              _groceryList.remove(_groceryList[index]);
            });
          },
          child: ListTile(
            title: Text(_groceryList[index].name),
            leading: Container(
              height: 24,
              width: 24,
              color: _groceryList[index].category.color,
            ),
            trailing: Text(_groceryList[index].quantity.toString()),
          ),
        )
    );

    if (_groceryList.isEmpty){
      activeWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Oops!! No items Available at the moment', style: Theme.of(context).textTheme.titleLarge,),
          const SizedBox(height: 10,),
          Text('Try adding some items', style: Theme.of(context).textTheme.labelMedium,),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: _addItem, icon: Icon(Icons.add)),
        ],
      ),
      body: activeWidget,
    );
  }
}
