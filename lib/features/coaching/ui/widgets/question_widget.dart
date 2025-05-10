import 'package:flutter/material.dart';
import '../../models/question.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final dynamic initialValue;
  final Function(dynamic) onChanged;

  const QuestionWidget({
    Key? key,
    required this.question,
    this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late dynamic value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.question.type) {
      case QuestionType.text:
        return _buildTextInput();
      case QuestionType.number:
        return _buildNumberInput();
      case QuestionType.boolean:
        return _buildBooleanInput();
      case QuestionType.singleChoice:
        return _buildSingleChoiceInput();
      case QuestionType.multipleChoice:
        return _buildMultipleChoiceInput();
      case QuestionType.dropdown:
        return _buildDropdownInput();
      case QuestionType.slider:
        return _buildSliderInput();
      case QuestionType.date:
        return _buildDateInput();
      default:
        return Text('Unsupported question type');
    }
  }

  Widget _buildTextInput() {
    return TextField(
      controller: TextEditingController(text: value?.toString() ?? ''),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your answer',
      ),
      maxLines: 3,
      onChanged: (newValue) {
        setState(() {
          value = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }

  Widget _buildNumberInput() {
    return TextField(
      controller: TextEditingController(text: value?.toString() ?? ''),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a number',
      ),
      keyboardType: TextInputType.number,
      onChanged: (newValue) {
        final numberValue = int.tryParse(newValue) ?? 0;
        setState(() {
          value = numberValue;
        });
        widget.onChanged(numberValue);
      },
    );
  }

  Widget _buildBooleanInput() {
    return Column(
      children: [
        RadioListTile<bool>(
          title: Text('Yes'),
          value: true,
          groupValue: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
            widget.onChanged(newValue);
          },
        ),
        RadioListTile<bool>(
          title: Text('No'),
          value: false,
          groupValue: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
            widget.onChanged(newValue);
          },
        ),
      ],
    );
  }

  Widget _buildSingleChoiceInput() {
    return Column(
      children: widget.question.options.map((option) {
        return RadioListTile<String>(
          title: Text(option.text),
          value: option.id,
          groupValue: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
            widget.onChanged(newValue);
          },
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoiceInput() {
    // Initialize value as a list if it's null
    if (value == null) {
      value = <String>[];
    }

    return Column(
      children: widget.question.options.map((option) {
        return CheckboxListTile(
          title: Text(option.text),
          value: (value as List).contains(option.id),
          onChanged: (selected) {
            setState(() {
              if (selected!) {
                (value as List).add(option.id);
              } else {
                (value as List).remove(option.id);
              }
            });
            widget.onChanged(value);
          },
        );
      }).toList(),
    );
  }

  Widget _buildDropdownInput() {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      items: widget.question.options.map((option) {
        return DropdownMenuItem<String>(
          value: option.id,
          child: Text(option.text),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          value = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }

  Widget _buildSliderInput() {
    // Default slider range
    double min = 0.0;
    double max = 100.0;
    int divisions = 100;

    // You could extract these from question options or metadata

    return Column(
      children: [
        Slider(
          value: (value ?? min).toDouble(),
          min: min,
          max: max,
          divisions: divisions,
          label: value?.toString() ?? '0',
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
            widget.onChanged(newValue);
          },
        ),
        Text(
          'Value: ${value?.toStringAsFixed(1) ?? '0.0'}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInput() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (picked != null && picked != value) {
          setState(() {
            value = picked;
          });
          widget.onChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Select a date',
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value != null
                  ? '${value.day}/${value.month}/${value.year}'
                  : 'Select a date',
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}