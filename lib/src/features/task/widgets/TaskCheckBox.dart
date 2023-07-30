import 'package:flutter/material.dart';
import 'package:neways3/src/features/task/controllers/TaskController.dart';

class TaskCheckBox extends StatefulWidget {
  TaskController taskController;
  TaskCheckBox(this.taskController, {super.key});

  @override
  State<TaskCheckBox> createState() => _TaskCheckBoxState();
}

class _TaskCheckBoxState extends State<TaskCheckBox> {

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.green;
    }

    return Checkbox(
      splashRadius: 5,
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: widget.taskController.isCheckBoxChecked,
      onChanged: (bool? value) {
        setState(() {
          widget.taskController.isCheckBoxChecked = value!;
        });
        widget.taskController.update();
      },

    );
  }
}
