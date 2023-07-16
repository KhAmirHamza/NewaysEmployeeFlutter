import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neways3/src/utils/constants.dart';

/// This is Common App textfiled class.
class AppTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final TextEditingController textEditingControllerInside =
      TextEditingController();
  final String title;
  final String hint;
  final bool isListSelected;
  final bool obscureText;
  final List<SelectedListItem>? list;
  final TextInputType keyboardType;

  AppTextField({
    required this.textEditingController,
    required this.title,
    required this.hint,
    required this.isListSelected,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.list,
    Key? key,
  }) : super(key: key);

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();

  /// This is on text changed method which will display on city text field on changed.
  void onTextFieldTap() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: widget.list ?? [],
        selectedItems: (List<dynamic> selectedList) {
          String value = "";
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              value = item.value == null
                  ? item.name
                  : "${item.value} - ${item.name}";
              setState(() {
                widget.textEditingController.text = value;
                widget.textEditingControllerInside.text = item.name;
              });
            }
          }
          // showSnackBar(value.toString());
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
            style: TextStyle(
              color: Colors.grey.shade700,
            )),
        const HeightSpace(),
        TextFormField(
          controller: widget.textEditingControllerInside,
          cursorColor: Colors.black,
          onTap: widget.isListSelected
              ? () {
                  FocusScope.of(context).unfocus();
                  onTextFieldTap();
                }
              : null,
          readOnly: widget.isListSelected,
          keyboardType: widget.keyboardType,
          inputFormatters: [
            if (widget.keyboardType == TextInputType.number)
              FilteringTextInputFormatter.digitsOnly
          ],
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding:
                const EdgeInsets.only(left: 8, bottom: 0, top: 0, right: 15),
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}

/// This is Common App textfiled class.
class AppTextFieldMultiSelection extends StatefulWidget {
  final TextEditingController textEditingController;
  final String title;
  final String hint;
  final List<SelectedListItem>? list;

  const AppTextFieldMultiSelection({
    required this.textEditingController,
    required this.title,
    required this.hint,
    this.list,
    Key? key,
  }) : super(key: key);

  @override
  _AppTextFieldMultiSelectionState createState() =>
      _AppTextFieldMultiSelectionState();
}

class _AppTextFieldMultiSelectionState
    extends State<AppTextFieldMultiSelection> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();

  /// This is on text changed method which will display on city text field on changed.
  void onTextFieldTap() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: widget.list ?? [],
        selectedItems: (List<dynamic> selectedList) {
          List<String> list = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              list.add(item.name);
            }
          }
          setState(() {
            widget.textEditingController.text =
                list.toString().replaceAll('[', '').replaceAll(']', '');
          });
          // showSnackBar(list.toString());
        },
        enableMultipleSelection: true,
      ),
    ).showModal(context);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const SizedBox(
          height: 5.0,
        ),
        TextFormField(
          controller: widget.textEditingController,
          cursorColor: Colors.black,
          onTap: () {
            FocusScope.of(context).unfocus();
            onTextFieldTap();
          },
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding:
                const EdgeInsets.only(left: 8, bottom: 0, top: 0, right: 15),
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}

/// This is common class for 'REGISTER' elevated button.
class AppElevatedButton extends StatelessWidget {
  String label;
  final VoidCallback onPressed;
  IconData? icon;
  Color? backgroundColor;

  AppElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 45.0,
      child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor ?? DColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: onPressed,
          icon: Icon(icon ?? Icons.search),
          label: Text(
            label,
            style: const TextStyle(fontSize: 16),
          )),
    );
  }
}
