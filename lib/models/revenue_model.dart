class RevenueModel{
  String? id;
  String? name;
  int? monthId;
  double? value;
  int? isPublic;

  RevenueModel({
    this.id,
    this.name,
    this.monthId,
    this.value,
    this.isPublic,
  });

  RevenueModel.fromJson(Map<String,dynamic> json) {
    id = json['id'];
    name = json['name'];
    monthId = json['month_id'];
    value = json['value'];
    isPublic = json['isPublic'];
  }

  Map<String,dynamic> toJson(){
    var data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['month_id'] = monthId;
    data['value'] = value;
    data['isPublic'] = isPublic;
    return data;
  }
}