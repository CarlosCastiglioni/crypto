class Coin {
  String icon;
  String name;
  String acronym;
  double price;

  Coin(
      {required this.icon,
      required this.name,
      required this.acronym,
      required this.price});

  Coin.fromJson(Map<String, dynamic> json)
      : icon = json["icon"],
        acronym = json["acronym"],
        name = json["name"],
        price = json["price"];

  Map<String, dynamic> toJson() =>
      {"icon": icon, "acronym": acronym, "name": name, "price": price};
}
