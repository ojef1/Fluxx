class CategoryModel {
  String? id;
  String? categoryName;
  double? price;

  CategoryModel({
    this.id,
    this.categoryName,
    this.price,
  });

  CategoryModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    categoryName = json['name'];
    price = json['price'];
  }

  Map<String,dynamic> toJson(){
    var data = <String,dynamic>{};
    data['id'] = id;
    data['name'] = categoryName;
    return data;
  }

  @override
  String toString() {
    return 'categoryName: $categoryName, id: $id';
  }
}
