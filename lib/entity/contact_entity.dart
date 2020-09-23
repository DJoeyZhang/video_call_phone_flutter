class ContactEntity {
  int errorCode;
  String errorMsg;
  List<Contact> data;

  ContactEntity({this.errorCode, this.errorMsg, this.data});

  ContactEntity.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = List<Contact>();
      json['data'].forEach((v) {
        data.add(Contact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contact {
  int userId;
  String nickName;
  int mobile;
  int serialNumber;
  String numberType;
  String linkUserRemark;
  String avatarColor;

  Contact(
      {this.userId,
      this.nickName,
      this.mobile,
      this.serialNumber,
      this.numberType,
      this.linkUserRemark,
      this.avatarColor});

  Contact.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    nickName = json['nickName'];
    mobile = json['mobile'];
    serialNumber = json['serialNumber'];
    numberType = json['numberType'];
    linkUserRemark = json['linkUserRemark'];
    avatarColor = json['avatarColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['nickName'] = this.nickName;
    data['mobile'] = this.mobile;
    data['serialNumber'] = this.serialNumber;
    data['numberType'] = this.numberType;
    data['linkUserRemark'] = this.linkUserRemark;
    data['avatarColor'] = this.avatarColor;
    return data;
  }
}
