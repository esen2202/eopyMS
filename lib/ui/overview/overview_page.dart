import 'package:eopy_management_system/http/overview_service.dart';
import 'package:eopy_management_system/models/overview.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {
  OverviewPage({Key key}) : super(key: key);

  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  OverviewService _overviewService;

  @override
  void initState() {
    _overviewService = OverviewService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          backgroundColor: Colors.green,
          title: Text('Genel Bakış'),
        ),
        FutureBuilder(
          future: _overviewService.getOverview(),
          builder: (BuildContext context, AsyncSnapshot<Overview> snapshot) {
            if (!snapshot.hasData) {
              return Expanded(
                  child: Center(
                child: CircularProgressIndicator(),
              ));
            }
            return Expanded(
              child: RefreshIndicator(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: <Widget>[
                    GridItem(
                      icon: Icons.work,
                      title: 'Total Orders',
                      total: snapshot.data.total,
                    ),
                    GridItem(
                      icon: Icons.add_shopping_cart,
                      title: 'Current Orders',
                      total: snapshot.data.current,
                    ),
                    GridItem(
                      icon: Icons.history,
                      title: 'Completed Orders',
                      total: snapshot.data.completed,
                    ),
                    GridItem(
                      icon: Icons.remove_shopping_cart,
                      title: 'Deleted Orders',
                      total: snapshot.data.deleted,
                    ),
                    GridItem(
                      icon: Icons.remove_shopping_cart,
                      title: 'Pending Orders',
                      total: snapshot.data.pending,
                    ),
                    GridItem(
                      icon: Icons.remove_shopping_cart,
                      title: 'Archived Orders',
                      total: snapshot.data.archived,
                    ),
                  ],
                ),
                onRefresh: () async {
                  setState(() {});
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class GridItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int total;

  const GridItem({
    @required this.icon,
    @required this.title,
    @required this.total,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              icon,
              size: 32,
              color: Colors.greenAccent,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 16,
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: Text(
                total.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
