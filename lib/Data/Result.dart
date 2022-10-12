class Result {
  String? result;
  bool? retriable;
  int? code;
  Data? data;
  String? description;
  int? ts;

  Result(
      {this.result,
        this.retriable,
        this.code,
        this.data,
        this.description,
        this.ts});

  Result.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    retriable = json['retriable'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    description = json['description'];
    ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['retriable'] = this.retriable;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['description'] = this.description;
    data['ts'] = this.ts;
    return data;
  }
}

class Data {
  String? phone;
  bool? locked;
  String? email;

  Data({this.phone, this.locked, this.email});

  Data.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    locked = json['locked'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['locked'] = this.locked;
    data['email'] = this.email;
    return data;
  }
}
