class SubCategoryModel {
  int? id;
  int? createdAt;
  String? title;
  String? status;
  int? categoriesId;

  SubCategoryModel(
      {this.id, this.createdAt, this.title, this.status, this.categoriesId});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    title = json['title'];
    status = json['status'];
    categoriesId = json['categories_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['title'] = title;
    data['status'] = status;
    data['categories_id'] = categoriesId;
    return data;
  }
}
