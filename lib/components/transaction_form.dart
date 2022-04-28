import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleControler = TextEditingController();

  final _valueController = TextEditingController();

  DateTime? _selectedDate = DateTime.now();

  // Using onSubmit again to be able to record new
  _submitForm() {
    final title = _titleControler.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }
    widget.onSubmit(title, value, _selectedDate!);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = pickedDate;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          //Elemento pra dar espaçamento
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            top: MediaQuery.of(context).viewInsets.top + 20,
          ),
          child: Column(
            children: <Widget>[
              TextField(
                autofocus: true,
                controller: _titleControler,
                onSubmitted: (_) => _submitForm(), // submit new transaction
                decoration: InputDecoration(
                  labelText: 'Título',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitForm(), // submit new transaction
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: 'Valor (R\$)',
                ),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'Nenhuma data selecionada.'
                          : DateFormat('dd/MM/y').format(_selectedDate!)),
                    ),
                    Container(
                      height: 70,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        ),
                        onPressed: _showDatePicker,
                        child: Text(
                          'Selecionar Data',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Nova Transação'),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      onSurface: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
