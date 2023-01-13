library my_prj.globals;

bool isLoggedIn = false;
int userID = 0;

class Plant {
  final int plantId;
  final String plantName;
  final String plantDescription;
  final int dayCount;
  final String picture;
  final int waterVolume;

  Plant({
    required this.plantId,
    required this.plantName,
    required this.plantDescription,
    required this.dayCount,
    required this.picture,
    required this.waterVolume,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plantId: int.parse(json['plant_id']),
      plantName: json['plant_name'],
      plantDescription: json['plant_description'],
      dayCount: int.parse(json['day_count']),
      picture: json['picture'],
      waterVolume: int.parse(json['water_volume']),
    );
  }
}
