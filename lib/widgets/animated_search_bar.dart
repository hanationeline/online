import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatelessWidget {
  final bool folded;
  final Function(String) onSearch;
  final Function onFoldChange;

  const AnimatedSearchBar({
    super.key,
    required this.folded,
    required this.onSearch,
    required this.onFoldChange,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: folded ? 56 : 270,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              child: !folded
                  ? TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.blue),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        onSearch(value);
                      },
                    )
                  : null,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(folded ? 32 : 0),
                  topRight: const Radius.circular(32),
                  bottomLeft: Radius.circular(folded ? 32 : 0),
                  bottomRight: const Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    folded ? Icons.search : Icons.close,
                    color: Colors.blue[900],
                  ),
                ),
                onTap: () {
                  onFoldChange();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
