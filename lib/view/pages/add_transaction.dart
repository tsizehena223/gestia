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
        body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SvgPicture.asset(
                  "assets/images/logo.svg",
                  colorFilter: ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
                  height: 200,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Text(
                  "Add Transaction",
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontSize: 25,
                    fontFamily: "Monospace",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40,),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 17, 141, 21),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusColor: Colors.white,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 17, 141, 21),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        labelText: "Title",
                        labelStyle: TextStyle(color: Theme.of(context).focusColor),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
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
                    const SizedBox(height: 20,),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 17, 141, 21),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusColor: Colors.white,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 17, 141, 21),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        labelText: "Amount",
                        labelStyle: TextStyle(color: Theme.of(context).focusColor),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      onChanged: (String? value) => {
                        if (value == null || value == "") {
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
                    const SizedBox(height: 20,),
                    DropdownButtonFormField<String>(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 17, 141, 21),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusColor: Colors.white,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 17, 141, 21),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        labelText: "Category",
                        labelStyle: TextStyle(color: Theme.of(context).focusColor),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
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
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: dateController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 17, 141, 21),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusColor: Colors.white,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 17, 141, 21),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        labelText: "Date",
                        suffixIcon: const Icon(Icons.calendar_month),
                        labelStyle: TextStyle(color: Theme.of(context).focusColor),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                  ],
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

/*
child: Column(
children: [
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
*/