import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required this.textEditingController,
    required this.onChanged,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _isFolded = true;
  final Duration _duration = const Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.center,
      width: _isFolded ? 50 : 200,
      padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
      height: 40,
      duration: _duration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_isFolded ? 50 : 50),
        color: _isFolded ? Colors.white : Colors.grey.shade200,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(right: 15),
              child: !_isFolded
                  ? TextField(
                      onChanged: (value) => widget.onChanged(value),
                      controller: widget.textEditingController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          AnimatedContainer(
            duration: _duration,
            child: GestureDetector(
              onTap: () => setState(() => _isFolded = !_isFolded),
              child: _isFolded
                  ? const Icon(
                      EvaIcons.searchOutline,
                      color: Colors.black87,
                    )
                  : GestureDetector(
                      child: const Icon(
                        EvaIcons.close,
                        color: Colors.black87,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
