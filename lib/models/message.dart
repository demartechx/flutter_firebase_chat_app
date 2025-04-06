

class Message {
  late final String toId;
  late final Type type;
  late final String msg;
  late final String read;
  late final String fromId;
  late final String sent;

  Message({required this.toId, required this.type, required this.msg, required this.read, required this.fromId, required this.sent});

  
  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    msg = json['msg'].toString();
    read = json['read'].toString();
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['toId'] = this.toId;
    data['type'] = this.type.name;
    data['msg'] = this.msg;
    data['read'] = this.read;
    data['fromId'] = this.fromId;
    data['sent'] = this.sent;
    return data;
  }

  
}

enum Type { text, image }