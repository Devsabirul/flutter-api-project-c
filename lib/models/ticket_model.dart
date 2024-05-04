class TicketsModel {
  int? id;
  String? subject;
  int? branchId;
  int? categoryId;
  int? subCategoryId;
  String? details;
  String? status;
  int? createdBy;
  int? solvedBy;
  String? createdAt;
  String? updatedAt;

  TicketsModel(
      {this.id,
      this.subject,
      this.branchId,
      this.categoryId,
      this.subCategoryId,
      this.details,
      this.status,
      this.createdBy,
      this.solvedBy,
      this.createdAt,
      this.updatedAt});

  TicketsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    branchId = json['branch_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    details = json['details'];
    status = json['status'];
    createdBy = json['created_by'];
    solvedBy = json['solved_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject'] = subject;
    data['branch_id'] = branchId;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['details'] = details;
    data['status'] = status;
    data['created_by'] = createdBy;
    data['solved_by'] = solvedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
