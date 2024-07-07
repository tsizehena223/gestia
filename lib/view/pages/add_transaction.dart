import 'package:flutter/material.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/components/header_widget.dart';
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
  TextEditingController dateController = TextEditingController();
  final List<String> _categories = ["expense", "income"];
  final List<IconData> _icons = [
    Icons.fastfood,
    Icons.local_hospital,
    Icons.card_giftcard,
    Icons.monetization_on,
    Icons.school,
    Icons.train,
  ];
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  String? _selectedCategory;
  DateTime? _selectedDate;
  IconData? _selectedIcon;
  Color? _selectedColor;

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
              const HeaderWidget(
                title: 'Add transaction',
                subtitle: 'Insert new transaction',
                icon: Icons.add,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: inputDecoration(context, 'Title'),
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
                        decoration: inputDecoration(context, 'Amount'),
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
                      const SizedBox(height: 20,),
                      DropdownButtonFormField<String>(
                        style: TextStyle(color: Theme.of(context).primaryColorLight),
                        dropdownColor: Theme.of(context).primaryColor,
                        decoration: inputDecoration(context, 'Category'),
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
                      // Icon
                      DropdownButtonFormField<IconData>(
                        style: TextStyle(color: Theme.of(context).primaryColorLight),
                        dropdownColor: Theme.of(context).disabledColor,
                        decoration: inputDecoration(context, 'Icon'),
                        value: _selectedIcon,
                        onChanged: (IconData? newIcon) {
                          setState(() {
                            _selectedIcon = newIcon;
                          });
                        },
                        items: _icons.map((IconData icon) {
                          return DropdownMenuItem<IconData>(
                            alignment: Alignment.center,
                            value: icon,
                            child: Row(
                              children: [
                                Icon(icon, color: Theme.of(context).primaryColorLight,),
                                const SizedBox(width: 10),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      // End icon
                      DropdownButtonFormField<Color>(
                        value: _selectedColor,
                        style: TextStyle(color: Theme.of(context).primaryColorLight),
                        decoration: inputDecoration(context, 'Color'),
                        onChanged: (Color? newColor) {
                          setState(() {
                            _selectedColor = newColor;
                          });
                        },
                        items: _colors.map((Color color) {
                          return DropdownMenuItem<Color>(
                            value: color,
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  color: color,
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: dateController,
                        style: const TextStyle(color: Colors.white),
                        decoration: inputDecoration(context, 'Date'),
                        readOnly: true,
                        onTap: () {
                          _selectDate(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: (
                  _isInputTitleValid &&
                  _isInputAmountValid &&
                  _selectedCategory != null &&
                  _selectedDate != null &&
                  _selectedColor != null &&
                  _selectedIcon != null
                ) ? true : false,
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
                        iconCode: _selectedIcon?.codePoint ?? Icons.monetization_on.codePoint,
                        color: _selectedColor ?? Theme.of(context).focusColor,
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
                      Navigator.pushReplacement(
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

  InputDecoration inputDecoration(BuildContext context, String label) {
    return InputDecoration(
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
      labelText: label,
      labelStyle: TextStyle(color: Theme.of(context).focusColor),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}