class SelectModel {
  final int ID;
  final String Name;

  SelectModel(this.ID, this.Name);

  factory SelectModel.fromMap(Map<String, dynamic> json) {
    return SelectModel(
      json["id"] ?? "",
      json["name"] ?? "",
    );
  }
}
