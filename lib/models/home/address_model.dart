class Address {
  final int addressId;
  final String streetNumber;
  final String houseNumber;
  final String mapAddress;
  final bool isDefault;
  final DateTime createdAt;

  Address({
    required this.addressId,
    required this.streetNumber,
    required this.houseNumber,
    required this.mapAddress,
    required this.isDefault,
    required this.createdAt,
  });

  // Factory constructor to create an Address from a JSON map
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['address_id'] as int,
      streetNumber: json['street_number'] as String,
      houseNumber: json['house_number'] as String,
      mapAddress: json['map_address'] as String,
      isDefault: json['is_default'] == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Method to convert an Address instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'street_number': streetNumber,
      'house_number': houseNumber,
      'map_address': mapAddress,
      'is_default': isDefault ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Factory method to create a list of Address objects from a JSON list
  static List<Address> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Address.fromJson(json)).toList();
  }
}


class DefaultAddress {
  final int addressId;
  final String streetNumber;
  final String houseNumber;
  final String mapAddress;
  final DateTime createdAt;

  DefaultAddress({
    required this.addressId,
    required this.streetNumber,
    required this.houseNumber,
    required this.mapAddress,
    required this.createdAt,
  });

  // Factory constructor to create an Address from a JSON map
  factory DefaultAddress.fromJson(Map<String, dynamic> json) {
    return DefaultAddress(
      addressId: json['address_id'] as int,
      streetNumber: json['street_number'] as String,
      houseNumber: json['house_number'] as String,
      mapAddress: json['map_address'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Method to convert an Address instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'street_number': streetNumber,
      'house_number': houseNumber,
      'map_address': mapAddress,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Factory method to create a list of Address objects from a JSON list
  static List<Address> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Address.fromJson(json)).toList();
  }
}
