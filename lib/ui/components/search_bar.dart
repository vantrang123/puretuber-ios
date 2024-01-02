import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:free_tuber/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../provider/search_provider.dart';

class SearchAppBar extends StatefulWidget {
  final Function(String) onFieldSubmittedCallback;

  SearchAppBar(this.onFieldSubmittedCallback);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 8),
              child: InkWell(
                onTap: () {
                  ManagerSearchProvider manager = Provider.of<ManagerSearchProvider>(context, listen: false);
                  manager.searchController.clear();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset('assets/images/ic_arrow_left.svg'),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 8, top: 8, right: 12),
                  height: kToolbarHeight * 0.7,
                  decoration: BoxDecoration(
                      color: Theme.of(context).iconTheme.color?.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(22)),
                  child: Row(
                    children: [
                      Expanded(
                        child: _searchBarTextField(),
                      ),
                      Consumer<ManagerSearchProvider>(builder: (context, manager, _) {
                        return AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: manager.searchController.text.isNotEmpty &&
                                    manager.showSearchBar
                                ? IconButton(
                                    padding: EdgeInsets.all(8),
                                    icon: Icon(Icons.clear, size: 18, color: Colors.white),
                                    onPressed: () {
                                      manager.searchController.clear();
                                      manager.searchBarFocusNode.requestFocus();
                                      manager.setState();
                                    },
                                  )
                                : SizedBox.shrink());
                      }),
                      FutureBuilder<dynamic>(
                          future: _getClipboardData(),
                          builder: (context, dynamic id) {
                            return AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: id.data != null && true
                                    ? IconButton(
                                        icon: Icon(EvaIcons.link,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            size: 20),
                                        onPressed: () {},
                                      )
                                    : Container());
                          }),
                    ],
                  )),
            )
          ],
        ));
  }

  Future<dynamic> _getClipboardData() async {
    String data = (await Clipboard.getData("text/plain"))?.text ?? "";
    if (data.isEmpty) {
      return null;
    }

    return null;
  }

  Widget _searchBarTextField() {
    return Consumer<ManagerSearchProvider>(builder: (context, manager, _) {
      return Padding(
        padding: EdgeInsets.only(left: 16),
        child: TextFormField(
          autofocus: true,
          autocorrect: false,
          controller: manager.searchController,
          focusNode: manager.searchBarFocusNode,
          onTap: () {
            manager.searchBarFocusNode.requestFocus();
            manager.setState();
          },
          style: TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            icon: Icon(Iconsax.search_normal, size: 18, color: Colors.white),
            hintText: 'Search anything',
            contentPadding: EdgeInsets.only(bottom: 11),
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textHint,
            ),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
          onFieldSubmitted: (String query) {
            FocusScope.of(context).unfocus();
            manager.searchRunning = true;
            manager.setState();
            widget.onFieldSubmittedCallback(query);
          },
          onChanged: (_) {
            manager.setState();
          },
        ),
      );
    });
  }
}
