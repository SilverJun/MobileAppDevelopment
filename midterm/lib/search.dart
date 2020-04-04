
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchPageState();
}


class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class FilterOption {
  FilterOption({this.name, this.isChecked});
  String name;
  bool isChecked;
}

class SearchPageState extends State<SearchPage> {
  List<Item> _data = generateItems(1);
  DateTime checkinDate = DateTime.now();
  DateTime checkoutDate = DateTime.now();

  List<FilterOption> _filters = [
    FilterOption(name: 'No Kids Zone', isChecked: false),
    FilterOption(name: 'Pet-Friendly', isChecked: false),
    FilterOption(name: 'Free breakfast', isChecked: false),
    FilterOption(name: 'Free Wi-Fi', isChecked: false),
    FilterOption(name: 'Electric Car Charging', isChecked: false),
  ];

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Check your choice =]'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.filter_list),
                    SizedBox(width: 8,),
                    Flexible(
                      child: Text(_filters.where((filter)=>filter.isChecked).map((filter)=>filter.name).toString(),),
                    )
                  ],
                ),
                SizedBox(height: 8,),
                Row(
                  children: <Widget>[
                    Icon(Icons.date_range),
                    SizedBox(width: 8,),
                    Column(
                      children: <Widget>[
                        Text('In ' + checkinDate.toString()),
                        Text('Out ' + checkoutDate.toString())
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search'),),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _neverSatisfied();
        },
        label: Text('Search', style: TextStyle(fontSize: 20),),
        icon: Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        color: Colors.white,
        child: ListView(

          children: <Widget>[
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _data[index].isExpanded = !isExpanded;
                });
              },
              children: _data.map<ExpansionPanel>((Item item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      leading: Text("Filter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      title: Center(
                        child: Text("select filters"),
                      ),
                    );
                  },
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _filters.map((filter) {
                      return Row(
                        children: <Widget>[
                          SizedBox(width: 130,),
                          Checkbox(
                            value: filter.isChecked,
                            onChanged: (bool value) {
                              setState(() {
                                filter.isChecked = value;
                              });
                            },
                          ),
                          Text(filter.name)
                        ],
                      );
                    }).toList(),
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),

            ListTile(
              leading: Text("Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('📆 Check-in', style: Theme.of(context).textTheme.subhead,),
                RaisedButton(
                  color: Color.fromRGBO(180, 215, 251, 1.0),
                  child: Text('Select Date'),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: checkinDate,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2030),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      },
                    ).then((date) {
                      checkinDate = date;
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('📆 Check-out', style: Theme.of(context).textTheme.subhead,),
                RaisedButton(
                  color: Color.fromRGBO(180, 215, 251, 1.0),
                  child: Text('Select Date'),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: checkoutDate,
                      firstDate: DateTime(2018),
                      lastDate: DateTime(2030),
                      builder: (BuildContext context, Widget child) {
                        return Theme(
                          data: ThemeData.dark(),
                          child: child,
                        );
                      },
                    ).then((date){
                      checkoutDate = date;
                    });
                  },
                )
              ],
            )
          ]
        ),
      ),
    );
  }
}