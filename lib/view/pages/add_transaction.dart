import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestia/utils/shared_preferences_util.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  bool _isInputTitleValid = false;
  bool _isInputAmountValid = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final List<String> _categories = ["expense", "income"];
  String? _selectedCategory;
  DateTime? _selectedDate;

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateController.text = "${picked.toLocal()}".split(' ')[0]; // format date as needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: SvgPicture.asset("assets/images/welcome.svg", height: 200, width: 200,),
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Theme.of(context).primaryColorLight),
              onChanged: (String? value) => {
                if (value == null || value == "") {
                  setState(
                    () {
                      _isInputTitleValid = false;
                    }
                  )
                } else {
                  setState(() {
                    _isInputTitleValid = true;
                  })
                },
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Theme.of(context).primaryColorLight),
              onChanged: (String? value) => {
                if (value == null || value == "" || int.tryParse(value) == null) {
                  setState(
                    () {
                    _isInputAmountValid = false;
                    }
                  )
                } else {
                  setState(() {
                    _isInputAmountValid = true;
                  })
                },
              },
            ),
            DropdownButtonFormField<String>(
              style: TextStyle(color: Theme.of(context).primaryColorLight),
              decoration: const InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: Colors.white),
              ),
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: _categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextFormField(
              controller: dateController,
              style: TextStyle(color: Theme.of(context).primaryColorLight),
              decoration: const InputDecoration(
                labelText: 'Date',
                labelStyle: TextStyle(color: Colors.white),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(context);
              },
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: (_isInputTitleValid && _isInputAmountValid) ? true : false,
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  onPressed: !(_isInputTitleValid && _isInputAmountValid) ? null : () async {
                    await SharedPreferencesUtil.storeBalance(0);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 70,
                    ),
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                  child: const Text(
                    "Save Transaction",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}