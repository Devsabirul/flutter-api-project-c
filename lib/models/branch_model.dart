class BranchModel {
  int? id;
  int? createdAt;
  String? name;
  String? address;
  String? routing;
  int? updatedAt;
  String? status;

  BranchModel(
      {this.id,
      this.createdAt,
      this.name,
      this.address,
      this.routing,
      this.updatedAt,
      this.status});

  BranchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    name = json['name'];
    address = json['address'];
    routing = json['routing'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['name'] = name;
    data['address'] = address;
    data['routing'] = routing;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    return data;
  }
}
