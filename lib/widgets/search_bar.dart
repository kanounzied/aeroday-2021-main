import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

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
        width: MediaQuery.of(context).size.width * 0.85,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white10,
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 2, blurRadius: 2)
          ],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 15),
          height: 30,
          child: TextField(
            controller: fieldText,
            cursorColor: red,
            cursorHeight: 18,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.white),
              hintText: 'Search...',
              border: InputBorder.none,
              suffixIcon: IconButton(
                splashRadius: 1,
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    FocusScope.of(context).unfocus();
                  });
                },
              ),
            ),
            onChanged: widget.onSearchTextChanged,
          ),
        ),
      ),
    );
  }
}

/*
FloatingSearchBar(
      builder: (context, transition) {
        return Container(
          height: 100,
        );
      }, //search list
      transitionDuration: const Duration(milliseconds: 400),
      transitionCurve: Curves.easeInOut,
      hint: 'Search...',
      width: 0.8 * MediaQuery.of(context).size.width,
      debounceDelay: const Duration(milliseconds: 400),
      borderRadius: BorderRadius.circular(6),
      height: 39,
      automaticallyImplyDrawerHamburger: false,
      automaticallyImplyBackButton: false,
      iconColor: dark,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      backdropColor: Colors.transparent,
      onQueryChanged: widget.onSearchTextChanged,
    )*/