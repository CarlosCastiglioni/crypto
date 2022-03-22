class Coin {
  String icon;
  String name;
  String acronym;
  double price;
  String baseId;
  DateTime timestamp;
  double changeTime;
  double changeDay;
  double changeWeek;
  double changeMonth;
  double changeYear;
  double changeAllPeriod;

  Coin(
      {required this.icon,
      required this.name,
      required this.acronym,
      required this.price,
      required this.baseId,
      required this.timestamp,
      required this.changeTime,
      required this.changeDay,
      required this.changeWeek,
      required this.changeMonth,
      required this.changeYear,
      required this.changeAllPeriod});

  Coin.fromJson(Map<String, dynamic> json)
      : icon = json["icon"],
        acronym = json["acronym"],
        name = json["name"],
        price = json["price"],
        baseId = json["baseId"],
        timestamp = json["timestamp"],
        changeTime = json["changeTime"],
        changeDay = json["changeDay"],
        changeWeek = json["changeWeek"],
        changeMonth = json["changeMonth"],
        changeYear = json["changeYear"],
        changeAllPeriod = json["changeAllPeriod"];

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "acronym": acronym,
        "name": name,
        "price": price,
        "baseId": baseId,
        "timestamp": timestamp,
        "changeTime": changeTime,
        "changeDay": changeDay,
        "changeWeek": changeWeek,
        "changeMonth": changeMonth,
        "changeYear": changeYear,
        "changeAllPeriod": changeAllPeriod
      };
}
