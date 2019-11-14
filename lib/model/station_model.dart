class StationModel{
    var id;
    var name;
    var url;
    var logoUrl;
    var frequency;
    var ciudad;

    StationModel(this.id, this.name, this.url, this.logoUrl, this.frequency, this.ciudad);
    StationModel.fromJson(Map<String, dynamic> json){
      this.id = json['id'];
      this.name = json['name'];
      this.url = json['url'];
      this.logoUrl = json['logoUrl'];
      this.frequency = json['frequency'];
      this.ciudad = json['ciudad'];
    }
}