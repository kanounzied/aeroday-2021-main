import 'package:aeroday2021/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:aeroday2021/config/responsive_size.dart';

class SearchBar extends StatefulWidget {
  Function(String) onSearchTextChanged;
  SearchBar({required this.onSearchTextChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final fieldText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SizeConfig.screenWidth * 0.85,
        height: 3.9 * SizeConfig.defaultSize,
        decoration: BoxDecoration(
          color: Colors.white10,
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                spreadRadius: .2 * SizeConfig.defaultSize,
                blurRadius: .2 * SizeConfig.defaultSize)
          ],
          borderRadius: BorderRadius.circular(.7 * SizeConfig.defaultSize),
        ),
        child: Center(
          child: Container(
            margin:
                EdgeInsets.symmetric(horizontal: 1.5 * SizeConfig.defaultSize),
            child: TextField(
              controller: fieldText,
              cursorColor: red,
              cursorHeight: 1.8 * SizeConfig.defaultSize,
              style: TextStyle(
                color: Colors.white,
                fontSize: 1.7 * SizeConfig.defaultSize,
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                hintText: 'Search...',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 1,
                  icon: Icon(
                    Icons.search,
                    size: 2.5 * SizeConfig.defaultSize,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                    });
                  },
                ),
              ),
              onSubmitted: widget.onSearchTextChanged,
              onChanged: widget.onSearchTextChanged,
            ),
          ),
        ),
      ),
    );
  }
}
