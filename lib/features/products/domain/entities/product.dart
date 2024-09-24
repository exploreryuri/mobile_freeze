import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime addedDate;
  final DateTime expiryDate;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.addedDate,
    required this.expiryDate,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, addedDate, expiryDate];
}
