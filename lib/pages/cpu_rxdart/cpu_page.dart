import 'package:flutter/material.dart';

import 'package:pc_build/models/part.dart';
import 'package:pc_build/widgets/widgets.dart';

import 'cpu_state.dart';
import 'cpu_filter.dart';

class CpuPage extends StatefulWidget {
  @override
  _CpuPageState createState() => _CpuPageState();
}

class _CpuPageState extends State<CpuPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool showSearch;

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchListener);
    cpuState.loadData();
    showSearch = cpuState.searchEnable;
    searchController.text = cpuState.searchString;
  }

  showMessage(String txt) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(txt),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    myTextStyle.init(); // call reinit text style to work with hot reload

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarBuilder(context),
      body: Container(
        decoration: MyBackgroundDecoration2(),
        child: bodyBuilder(),
      ),
    );
  }

  searchListener() {
    if (showSearch) {
      cpuState.search(searchController.text, true);
    }
  }

  toggleSearch() {
    setState(() {
      showSearch = !showSearch;
      if (!showSearch) cpuState.search(searchController.text, false);
    });
  }

  AppBar appBarBuilder(BuildContext context) {
    return AppBar(
      title: Text('CPU'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () {
            toggleSearch();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.tune,
          ),
          tooltip: 'Filter',
          onPressed: () {
            navigate2filterPage(context);
          },
        ),
        PopupMenuButton(
          onSelected: (v) => cpuState.sort(v),
          icon: Icon(Icons.sort),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Latest'),
                value: PartSort.latest,
              ),
              PopupMenuItem(
                child: Text('Low price'),
                value: PartSort.lowPrice,
              ),
              PopupMenuItem(
                child: Text('High price'),
                value: PartSort.highPrice,
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget bodyBuilder() {
    return Column(
      children: <Widget>[
        showSearch
            ? SearchField(
                searchController: searchController,
              )
            : SizedBox(),
        Expanded(
          child: listBuilder(),
        ),
      ],
    );
  }

  Widget listBuilder() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: cpuState.loadData,
      child: StreamBuilder<List<Part>>(
        stream: cpuState.list,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                var v = snapshot.data[i];
                return PartTile(
                  image: v.picture,
                  url: v.path ?? '',
                  title: v.brand,
                  subTitle: v.model,
                  price: v.price,
                  index: i,
                  onAdd: (i) {
                    Navigator.pop(context, v);
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  navigate2filterPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CpuFilterPage()),
    );
  }
}