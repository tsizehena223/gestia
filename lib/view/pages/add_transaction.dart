import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestia/model/transaction.dart';
import 'package:gestia/model/transaction_history.dart';
import 'package:gestia/service/transaction_history_service.dart';
import 'package:gestia/service/transaction_service.dart';
import 'package:gestia/utils/shared_preferences_util.dart';
import 'package:gestia/view/components/header_widget.dart';
import 'package:gestia/view/components/snack_bar_message.dart';
import 'package:gestia/view/pages/home.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddTransaction extends StatefulWidget {
  final String? defaultCategory;

  const AddTransaction({
    super.key,
    required this.defaultCategory,
  });

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  var uuid = const Uuid().v1();
  bool _isInputTitleValid = false;
  bool _isInputAmountValid = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final List<String> _categories = ["expense", "income"];

  final Map<IconData, String> _icons = {
    Icons.fastfood: 'Food',
    Icons.local_hospital: 'Health',
    Icons.card_giftcard: 'Gift',
    Icons.monetization_on: 'Salary',
    Icons.school: 'Education',
    Icons.train: 'Travel',
    Icons.devices_other: 'Other'
  };

  String? _selectedCategory;
  DateTime? _selectedDate;
  IconData? _selectedIcon;

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    // Set the defaultCategory to valid
    if (widget.defaultCategory != null) {
      _selectedCategory = widget.defaultCategory;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Color _getColorForIcon(IconData ic) {
    switch (ic) {
      case Icons.fastfood:
        return Colors.orange;
      case Icons.local_hospital:
        return Colors.yellow;
      case Icons.train:
        return Colors.blue;
      case Icons.card_giftcard:
        return Colors.purple;
      case Icons.monetization_on:
        return Colors.green;
      case Icons.school:
        return Colors.red;
      case Icons.devices_other:
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionBox = Hive.box<Transaction>(TransactionService.boxName);
    final transactionHistoryBox =
        Hive.box<TransactionHistory>(TransactionHistoryService.boxName);

    return SafeArea(
      child: Scaffold(
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
                logo(context),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.text,
                          controller: titleController,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: inputDecoration(context, 'Title'),
                          onChanged: (String? value) => {
                            if (value == null || value == "")
                              {
                                setState(() {
                                  _isInputTitleValid = false;
                                })
                              }
                            else
                              {
                                setState(() {
                                  _isInputTitleValid = true;
                                })
                              },
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: amountController,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: inputDecoration(context, 'Amount'),
                          onChanged: (String? value) => {
                            if (!_validatePositiveNumber(value))
                              {
                                setState(() {
                                  _isInputAmountValid = false;
                                })
                              }
                            else
                              {
                                setState(() {
                                  _isInputAmountValid = true;
                                })
                              },
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField<String>(
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          dropdownColor: const Color.fromARGB(255, 42, 4, 87).withOpacity(.9),
                          decoration: inputDecoration(context, 'Category'),
                          value: widget.defaultCategory,
                          onChanged: (widget.defaultCategory != null)
                              ? null
                              : (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                          items: _categories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Icon
                        DropdownButtonFormField<IconData>(
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          dropdownColor: const Color.fromARGB(255, 42, 4, 87).withOpacity(.9),
                          decoration: inputDecoration(context, 'Icon'),
                          value: _selectedIcon,
                          onChanged: (IconData? newIcon) {
                            setState(() {
                              _selectedIcon = newIcon;
                            });
                          },
                          items: _icons.entries.map((entry) {
                            return DropdownMenuItem<IconData>(
                              alignment: Alignment.center,
                              value: entry.key,
                              child: Row(
                                children: [
                                  Icon(
                                    entry.key,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(entry.value),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        // End icon
                        TextFormField(
                          controller: dateController,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: inputDecoration(context, 'Date'),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                        Visibility(
                          visible: (_isInputTitleValid &&
                                  _isInputAmountValid &&
                                  _selectedCategory != null &&
                                  _selectedDate != null &&
                                  _selectedIcon != null)
                              ? true
                              : false,
                          child: Container(
                            margin: const EdgeInsets.only(top: 30),
                            height: 50,
                            child: ElevatedButton(
                              onPressed: !(_isInputTitleValid &&
                                      _isInputAmountValid)
                                  ? null
                                  : () async {
                                      // check if the amount entered is higher thant the actual balance
                                      int currentBalance =
                                          await SharedPreferencesUtil
                                                  .retrieveBalance() ??
                                              0;
                                      if ((int.parse(amountController.text) >
                                              currentBalance) &&
                                          (_selectedCategory == "expense")) {
                                        // ignore: use_build_context_synchronously
                                        showErrorMessage(context,
                                            "You don't have enough money");
                                        return;
                                      }

                                      // Store data
                                      Transaction newTransaction = Transaction(
                                        key: uuid,
                                        title: titleController.text,
                                        amount: (int.parse(
                                                    amountController.text) <
                                                0)
                                            ? -int.parse(amountController.text)
                                            : int.parse(amountController.text),
                                        category: _selectedCategory ?? "income",
                                        date: _selectedDate ?? DateTime.now(),
                                        iconCode: _selectedIcon?.codePoint ??
                                            Icons.monetization_on.codePoint,
                                        color: _getColorForIcon(_selectedIcon ??
                                            Icons.monetization_on),
                                        // ignore: use_build_context_synchronously
                                      );
                                      transactionBox.add(newTransaction);
                                      // End store data

                                      // Add transaction to the transaction history
                                      final year = _selectedDate?.year ?? DateTime.now().year;
                                      final month = DateFormat.MMMM().format(_selectedDate ?? DateTime.now());
                                      final transactionHistoryService = TransactionHistoryService();
                                      
                                      // Find existing transaction history for the year and month
                                      final existingHistoryKey = transactionHistoryBox.keys.firstWhere(
                                        (key) {
                                          final entry = transactionHistoryBox.get(key) as TransactionHistory;
                                          return entry.year == year && entry.month == month;
                                        },
                                        orElse: () => null,
                                      );
                                      
                                      if (existingHistoryKey == null) {
                                        // If no entry exists, create a new one and use the service to add it
                                        final newTransactionHistory = TransactionHistory(
                                          month: month,
                                          year: year,
                                          expense: _selectedCategory == "expense" ? int.parse(amountController.text) : 0,
                                          income: _selectedCategory == "income" ? int.parse(amountController.text) : 0,
                                          key: uuid,
                                        );
                                        transactionHistoryService.addTransactionHistory(newTransactionHistory);
                                      } else {
                                        // If entry exists, update it and use the service to update
                                        final existingHistory = transactionHistoryBox.get(existingHistoryKey) as TransactionHistory;
                                      
                                        if (_selectedCategory == "expense") {
                                          existingHistory.expense += int.parse(amountController.text);
                                        } else {
                                          existingHistory.income += int.parse(amountController.text);
                                        }
                                      
                                        // Update using the service method
                                        transactionHistoryService.updateTransactionHistory(existingHistoryKey, existingHistory);
                                      }

                                      // Update balance
                                      int amount;
                                      if (_selectedCategory == "expense") {
                                        amount =
                                            -int.parse(amountController.text);
                                      } else {
                                        amount =
                                            int.parse(amountController.text);
                                      }
                                      await SharedPreferencesUtil.storeBalance(
                                          currentBalance + amount);
                                      // End update balance
                                      showSuccessMessage(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        "Transaction added successfully",
                                      );

                                      Navigator.pushReplacement(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Home()),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 70,
                                ),
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                              ),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0),
      ),
    );
  }

  Container logo(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor.withOpacity(.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            "assets/images/logo.svg",
            colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColorDark.withOpacity(.8), BlendMode.srcIn),
            height: 120,
          ),
          Image.asset(
            "assets/images/ispm.png",
            height: 80,
          ),
        ],
      ),
    );
  }

  InputDecoration inputDecoration(BuildContext context, String label) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      focusColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).focusColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      labelText: label,
      labelStyle: TextStyle(color: Theme.of(context).focusColor),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  bool _validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return false;
    }
    return true;
  }
}
