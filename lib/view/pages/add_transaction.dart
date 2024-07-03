import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/pages/home.dart';
import 'package:hive/hive.dart';

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
        dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: const Center(
            child: Text(
              'Transaction added successfully',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transcationBox = Hive.box<Transaction>(TransactionService.boxName);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: SvgPicture.asset(
                  "assets/images/logo.svg",
                  colorFilter: ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
                  height: 200,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(20),
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).disabledColor,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: (_isInputTitleValid && _isInputAmountValid && _selectedCategory != null && _selectedDate != null) ? true : false,
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: 50,
                  child: ElevatedButton(
                    onPressed: !(_isInputTitleValid && _isInputAmountValid) ? null : () async {
                      // Store data
                      Transaction newTransaction = Transaction(
                        title: titleController.text,
                        amount: int.parse(amountController.text),
                        category: _selectedCategory ?? "income",
                        date: _selectedDate ?? DateTime.now(),
                        iconCode: Icons.card_giftcard.codePoint,
                      );
                      transcationBox.add(newTransaction);
                      // End store data
                      // Update balance
                      int currentBalance = await SharedPreferencesUtil.retrieveBalance() ?? 0;
                      int amount;
                      if (_selectedCategory == "expense") {
                        amount = - int.parse(amountController.text);
                      } else {
                        amount = int.parse(amountController.text);
                      }
                      await SharedPreferencesUtil.storeBalance(currentBalance + amount);
                      // End update balance
                      // ignore: use_build_context_synchronously
                      _showSuccessMessage(context);
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 70,
                      ),
                      backgroundColor: Theme.of(context).primaryColorDark,
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100,),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}