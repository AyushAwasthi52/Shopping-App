import 'package:flutter/material.dart';

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';


class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {

  var _enteredName = '';
  var _enteredQuantity = 1;
  var _enteredValue = categories[Categories.vegetables]!;

  final _formKey = GlobalKey<FormState>();

  void _saveItem(){
    if (_formKey.currentState!.validate()){
      _formKey.currentState!.save();
    }
    Navigator.of(context).pop(GroceryItem(
        id: DateTime.now().toString(),
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _enteredValue
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(key: _formKey, child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().length <=1 || value.trim().length > 50){
                  return 'The name value must be between 1 and 50 characters';
                }
                return null;
              },
              onSaved: (value) {
                _enteredName = value!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: 20,
                    initialValue: '1',
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(
                        label: Text('Quantity')
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! <= 0){
                        return 'The amount should be a positive number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredQuantity = int.parse(value!);
                    },
                  ),
                ),
                const SizedBox(width: 8,),
                Expanded(
                  child: DropdownButtonFormField(
                      value: _enteredValue,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    height: 22,
                                    width: 22,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(width: 6,),
                                  Text(category.key.name),
                                ],
                              )
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _enteredValue = value!;
                        });
                      },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {
                  _formKey.currentState!.reset();
                }, child: const Text('Reset')),
                const SizedBox(width: 8,),
                ElevatedButton(onPressed: _saveItem, child: const Text('Add Item'))
              ],
            )
          ],
        )),
      ),
    );
  }
}
