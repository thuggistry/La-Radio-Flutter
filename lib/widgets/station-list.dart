import 'package:flutter/material.dart';
import 'package:laradio/model/station_model.dart';

class StationList extends StatelessWidget{
  final List<StationModel> stations;
  StationList({Key key, @required this.stations}): super(key: key);

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: stations.length,
      itemBuilder: (context, index){
        print(stations[index].name);
        return Container(
          color: Color(0xFFFAFAFA),
          margin: EdgeInsets.only(top: 16, right: 8),
          child: GestureDetector(
                  onTap: (){
                    print(stations[index].name);
                    //this.playStation(stations[index]);
                  },
                    child: Card(
                    elevation: 4,
                      child: Image.network(stations[index].logoUrl)
                  ),
          ),
        );
      },
    );
  }
}