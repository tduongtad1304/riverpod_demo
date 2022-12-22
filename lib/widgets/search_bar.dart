import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key, this.onSearch}) : super(key: key);
  final Function(String)? onSearch;
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          suffixIcon: textController.text.isNotEmpty
              ? IconButton(
                  icon:
                      const Icon(Icons.close, size: 18, color: Colors.black54),
                  onPressed: () => setState(
                    () {
                      textController.clear();
                      widget.onSearch?.call(textController.text);
                    },
                  ),
                )
              : null,
          hintText: 'Search 🔍',
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          setState(
            () {
              TextSelection previousSelection = textController.selection;
              textController.text = value;
              textController.selection = previousSelection;
            },
          );
          widget.onSearch?.call(textController.text);
        },
      ),
    );
  }
}
