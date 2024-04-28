class TicketsModel {
  int? id;
  int? createdAt;
  String? subject;
  String? details;
  String? status;
  int? branchId;
  int? categoriesId;
  int? subcategoriesId;
  int? usersId;

  TicketsModel(
      {this.id,
      this.createdAt,
      this.subject,
      this.details,
      this.status,
      this.branchId,
      this.categoriesId,
      this.subcategoriesId,
      this.usersId});

  TicketsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    subject = json['subject'];
    details = json['details'];
    status = json['status'];
    branchId = json['branch_id'];
    categoriesId = json['categories_id'];
    subcategoriesId = json['subcategories_id'];
    usersId = json['users_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['subject'] = subject;
    data['details'] = details;
    data['status'] = status;
    data['branch_id'] = branchId;
    data['categories_id'] = categoriesId;
    data['subcategories_id'] = subcategoriesId;
    data['users_id'] = usersId;
    return data;
  }
}
