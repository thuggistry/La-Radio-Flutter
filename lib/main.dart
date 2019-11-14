import 'package:flutter/material.dart';
import 'dart:convert';
import './model/station_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:music_player/music_player.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  List<StationModel> stations = List<StationModel>();
  StationModel currentStation;
  final ciudades = ['Santiago', 'Santo Domingo', 'Puerto Rico'];
  MusicPlayer musicPlayer;
  bool isPlaying = false;

  void initState(){
    super.initState();
    loadStations();
    initPlatformState();
  }
   // Initializing the Music Player and adding a single [PlaylistItem]
  Future<void> initPlatformState() async {
    musicPlayer = MusicPlayer();
  }

  playStation(StationModel station){
    musicPlayer.play(MusicItem(
      trackName: station.name,
      albumName: station.frequency,
      artistName: station.ciudad,
      url: station.url,
      coverUrl: station.logoUrl,
      duration: Duration(seconds: 255),
      )
    );

    setState(() {
     currentStation = station; 
     isPlaying = true;
    });

  }

  Widget togglePlayPause(){
    return isPlaying ?
      IconButton(icon: Icon(Icons.pause_circle_filled), iconSize: 42, color: Colors.white, onPressed: (){ 
        musicPlayer.pause();
        setState(() {
         isPlaying = false; 
        });
        }, splashColor: Colors.transparent,)
      : IconButton(icon: Icon(Icons.play_arrow), iconSize: 42, color: Colors.white, onPressed: () =>{playStation(this.currentStation)}, splashColor: Colors.transparent,); 
  }
  void loadStations() async{
    //https://api.jsonbin.io/b/5d8d8af10a5a302875cf0822
    List<StationModel> tempStations = List<StationModel>();
    //var response =  await get('https://api.jsonbin.io/b/5d8d8af10a5a302875cf0822');
    var response = await rootBundle.loadString('assets/stations.json');
    tempStations = (json.decode(response) as List).map((e) => StationModel.fromJson(e)).toList();

    print('loadStations()');
    this.currentStation = tempStations[0];
    setState(() {
     this.stations = tempStations;
    });
    //return stations;
  }


  Widget renderMainList(context){
    print('renderMainList()');
    return ListView.builder(
      itemCount: this.ciudades.length,
      itemBuilder: (context, index){

        var stations =  this.stations.where((station)=> station.ciudad == ciudades[index]).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8, left: 8),
              child: Text(ciudades[index],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700
              ),),
            ),
            SizedBox(
              height: 120.0,
              child: renderStationsList(context, stations),
            ),
          ],
        ); 
      },
    );
  }
  Widget renderStationsList(context, List<StationModel> stations) {
    print('renderStationsList()');
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: stations.length,
      itemBuilder: (context, index){
        print(stations[index].name);
        return Container(
          color: Color(0xFFFAFAFA),
          margin: EdgeInsets.only(right: 4, bottom: 16, left: 4),
          child: GestureDetector(
                  onTap: (){
                    print(stations[index].name);
                    this.playStation(stations[index]);
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

//primary color #F44336
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
              Container(
                height: 210,
                padding: EdgeInsets.only(top: 50.0),
                color: Color(0xFFF44336),
                  child: Column(
                    children: <Widget>[
                      Text(currentStation.frequency + " FM", style: TextStyle(fontSize: 36,color: Colors.white),),
                      Text(currentStation.name + " - " + currentStation.ciudad, style: TextStyle(fontSize: 18,color: Color(0xFFFAB0AC),),),
                      Container(margin: EdgeInsets.only(top: 16.0),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.skip_previous), iconSize: 32, color: Colors.white, onPressed: () =>{}, splashColor: Colors.transparent,),
                          togglePlayPause(),
                          IconButton(icon: Icon(Icons.skip_next), iconSize: 32, color: Colors.white, onPressed: () =>{}, splashColor: Colors.blue,)
                        ],
                      ),
                    ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 0),
                  child: renderMainList(context)
                  )
                ),
          ],
        )
      ),
    );
  }
}