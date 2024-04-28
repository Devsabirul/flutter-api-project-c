class CategoryModel {
  int? id;
  int? createdAt;
  String? title;
  String? status;

  CategoryModel({this.id, this.createdAt, this.title, this.status});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['title'] = title;
    data['status'] = status;
    return data;
  }
}
