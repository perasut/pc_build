import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart';

import 'package:pc_build/widgets/widgets.dart';

import 'package:pc_build/models/mon.dart';

class MonFilterPage extends StatefulWidget {
  final MonFilter selectedFilter;
  final List<Mon> all;

  MonFilterPage({Key key, this.selectedFilter, this.all}) : super(key: key);

  @override
  _CpuFilterPageState createState() => _CpuFilterPageState();
}

class _CpuFilterPageState extends State<MonFilterPage> {
  MonFilter allFilter;
  MonFilter validFilter;
  MonFilter selectedFilter;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    allFilter = MonFilter.fromList(widget.all);
    validFilter = allFilter;
    selectedFilter = widget.selectedFilter;
    if (selectedFilter.maxPrice > allFilter.maxPrice)
      selectedFilter.maxPrice = allFilter.maxPrice;
    if (selectedFilter.minPrice < allFilter.minPrice)
      selectedFilter.minPrice = allFilter.minPrice;
    recalFilter();
  }

  resetData() {
    setState(() {
      allFilter = MonFilter.fromList(widget.all);
      validFilter = allFilter;
      selectedFilter = MonFilter();
      selectedFilter.minPrice = allFilter.minPrice;
      selectedFilter.maxPrice = allFilter.maxPrice;
    });
  }

  recalFilter() {
    setState(() {
      validFilter = MonFilter.clone(allFilter);
      var tmpFilter = MonFilter.clone(allFilter);

      //import price
      tmpFilter.minPrice = selectedFilter.minPrice;
      tmpFilter.maxPrice = selectedFilter.maxPrice;

      //filter valid brand
      var tmpList = tmpFilter.filters(widget.all);
      var resultFilter = MonFilter.fromList(tmpList);
      validFilter.brand = resultFilter.brand;
      selectedFilter.brand =
          selectedFilter.brand.intersection(validFilter.brand);

      //import brand
      tmpFilter.brand = allFilter.brand.intersection(selectedFilter.brand);

      //filter valid panel
      tmpList = tmpFilter.filters(widget.all);
      resultFilter = MonFilter.fromList(tmpList);
      validFilter.panel = resultFilter.panel;
      selectedFilter.panel =
          selectedFilter.panel.intersection(validFilter.panel);

      //import panel
      tmpFilter.panel = allFilter.panel.intersection(selectedFilter.panel);

      //filter valid size
      tmpList = tmpFilter.filters(widget.all);
      resultFilter = MonFilter.fromList(tmpList);
      validFilter.size = resultFilter.size;
      selectedFilter.size = selectedFilter.size.intersection(validFilter.size);
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<String> allBrandList = allFilter.vgaBrand.toList()..sort();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Filter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_backup_restore),
            tooltip: 'Reset',
            onPressed: () => resetData(),
          ),
          IconButton(
            icon: Icon(Icons.check),
            tooltip: 'OK',
            onPressed: () {
              Navigator.pop(context, selectedFilter);
            },
          ),
        ],
      ),
      body: Container(
        decoration: MyBackgroundDecoration3(),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('ราคา'),
              trailing: Text(
                  '${selectedFilter.minPrice}-${selectedFilter.maxPrice} \u{0e3f}'),
            ),
            RangeSlider(
              min: allFilter.minPrice.toDouble(),
              max: allFilter.maxPrice.toDouble(),
              lowerValue: selectedFilter.minPrice.toDouble(),
              upperValue: selectedFilter.maxPrice.toDouble(),
              divisions: 20,
              showValueIndicator: true,
              valueIndicatorMaxDecimals: 0,
              onChanged: (l, u) {
                setState(() {
                  selectedFilter.minPrice = l.toInt();
                  selectedFilter.maxPrice = u.toInt();
                  recalFilter();
                });
              },
            ),
            filterChipMaker('Brands', allFilter.brand, validFilter.brand,
                selectedFilter.brand),
            filterChipMaker('Panel', allFilter.panel, validFilter.panel,
                selectedFilter.panel),
            filterChipMaker(
                'Size', allFilter.size, validFilter.size, selectedFilter.size),
          ],
        ),
      ),
    );
  }

  Widget clearAllMaker(Set<String> selected) {
    return FlatButton(
      child: Text('clear'),
      onPressed: selected.length == 0
          ? null
          : () {
              setState(() {
                selected.clear();
                recalFilter();
              });
            },
    );
  }

  Widget filterChipMaker(
    String label,
    Set<String> all,
    Set<String> valid,
    Set<String> selected,
  ) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(label),
          trailing: clearAllMaker(selected),
        ),
        FilterChips(
          all: all,
          valid: valid,
          selected: selected,
          onSelected: (str) {
            setState(() {
              selected.add(str);
              recalFilter();
            });
          },
          onDeselected: (str) {
            setState(() {
              selected.remove(str);
              recalFilter();
            });
          },
        ),
      ],
    );
  }
}