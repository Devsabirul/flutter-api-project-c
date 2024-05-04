class BranchModel {
  int? id;
  String? name;
  String? address;
  int? routing;
  String? createdAt;
  String? updatedAt;
  List<Users>? users;
  List<Ticket>? ticket;

  BranchModel(
      {this.id,
      this.name,
      this.address,
      this.routing,
      this.createdAt,
      this.updatedAt,
      this.users,
      this.ticket});

  BranchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    routing = json['routing'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
    if (json['ticket'] != null) {
      ticket = <Ticket>[];
      json['ticket'].forEach((v) {
        ticket!.add(Ticket.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['routing'] = routing;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (ticket != null) {
      data['ticket'] = ticket!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? name;
  String? email;
  String? createdAt;
  String? updatedAt;

  Users({this.id, this.name, this.email, this.createdAt, this.updatedAt});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Ticket {
  int? id;
  String? subject;
  String? details;
  String? status;
  String? createdAt;
  String? updatedAt;

  Ticket(
      {this.id,
      this.subject,
      this.details,
      this.status,
      this.createdAt,
      this.updatedAt});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    details = json['details'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject'] = subject;
    data['details'] = details;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
