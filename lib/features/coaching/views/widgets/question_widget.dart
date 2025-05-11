import 'package:flutter/material.dart';
import '../../models/question.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final dynamic value;
  final Function(dynamic) onChanged;

  const QuestionWidget({
    Key? key,
    required this.question,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question text
        Text(
          question.text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),

        // Required indicator
        if (question.required)
          const Text(
            '* Required',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),

        // Question description if available
        if (question.description != null && question.description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: Text(
              question.description!,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Different input types based on question type
        _buildQuestionInput(context),
      ],
    );
  }

  Widget _buildQuestionInput(BuildContext context) {
    switch (question.type) {
      case QuestionType.text:
        return _buildTextInput(context);
      case QuestionType.singleChoice:
        return _buildSingleChoiceInput(context);
      case QuestionType.multipleChoice:
        return _buildMultipleChoiceInput(context);
      case QuestionType.number:
        return _buildNumberInput(context);
      case QuestionType.date:
        return _buildDateInput(context);
      case QuestionType.boolean:
        return _buildBooleanInput(context);
      case QuestionType.slider:
        return _buildSliderInput(context);
      case QuestionType.dropdown:
        return _buildDropdownInput(context);
    }
  }

  Widget _buildSingleChoiceInput(BuildContext context) {
    return Column(
      children: question.options.map((option) {
        return RadioListTile<String>(
          title: Text(option.text),
          value: option.id,
          groupValue: value as String?,
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).primaryColor,
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoiceInput(BuildContext context) {
    final selectedOptions = value as List<String>? ?? [];

    return Column(
      children: question.options.map((option) {
        return CheckboxListTile(
          title: Text(option.text),
          value: selectedOptions.contains(option.id),
          onChanged: (isChecked) {
            final List<String> updatedSelection = List.from(selectedOptions);

            if (isChecked ?? false) {
              if (!updatedSelection.contains(option.id)) {
                updatedSelection.add(option.id);
              }
            } else {
              updatedSelection.remove(option.id);
            }

            onChanged(updatedSelection);
          },
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).primaryColor,
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }

  Widget _buildTextInput(BuildContext context) {
    return TextFormField(
      key: ValueKey('text_${question.id}'),
      initialValue: value as String?,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: 'Enter your answer',
      ),
      maxLines: 1,
      onChanged: onChanged,
    );
  }

  Widget _buildNumberInput(BuildContext context) {
    return TextFormField(
      key: ValueKey('number_${question.id}'),
      initialValue: value?.toString() ?? '',
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: 'Enter a number',
      ),
      keyboardType: TextInputType.number,
      onChanged: (val) {
        // Convert to number if possible
        final number = double.tryParse(val);
        if (number != null) {
          onChanged(number);
        } else {
          onChanged(val);
        }
      },
    );
  }

  Widget _buildDateInput(BuildContext context) {
    // Format date for display
    String displayDate = '';
    if (value != null) {
      if (value is DateTime) {
        displayDate =
            '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
      } else {
        displayDate = value.toString();
      }
    }

    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: value is DateTime ? value : DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          onChanged(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayDate.isEmpty ? 'Select a date' : displayDate,
              style: TextStyle(
                color: displayDate.isEmpty ? Colors.grey[600] : Colors.black,
              ),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildBooleanInput(BuildContext context) {
    return Column(
      children: [
        RadioListTile<bool>(
          title: const Text('Yes'),
          value: true,
          groupValue: value as bool?,
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).primaryColor,
        ),
        RadioListTile<bool>(
          title: const Text('No'),
          value: false,
          groupValue: value as bool?,
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildDropdownInput(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value as String?,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      hint: const Text('Select an option'),
      items: question.options.map((option) {
        return DropdownMenuItem<String>(
          value: option.id,
          child: Text(option.text),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }

  Widget _buildSliderInput(BuildContext context) {
    // Default slider values
    final double currentValue = (value as double?) ?? 0.0;
    const double min = 0.0;
    const double max = 100.0;
    const double step = 1.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(min.toStringAsFixed(0)),
            Text(currentValue.toStringAsFixed(0)),
            Text(max.toStringAsFixed(0)),
          ],
        ),
        Slider(
          value: currentValue,
          min: min,
          max: max,
          divisions: ((max - min) / step).round(),
          label: currentValue.toStringAsFixed(0),
          onChanged: (value) {
            onChanged(value);
          },
        ),
      ],
    );
  }
}
