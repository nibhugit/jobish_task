class ProductListModel {
  ProductListModel({required this.products, this.total, this.skip, this.limit});

  factory ProductListModel.fromJson(final Map<String, dynamic> json) =>
      ProductListModel(
        products: json['products'] is List
            ? (json['products'] as List<dynamic>)
                  .map(
                    (final e) => Products.fromJson(e as Map<String, dynamic>),
                  )
                  .toList()
            : [],
        total: json['total'] as int?,
        skip: json['skip'] as int?,
        limit: json['limit'] as int?,
      );

  final List<Products> products;
  final int? total;
  final int? skip;
  final int? limit;

  Map<String, dynamic> toJson() => {
    'products': products.map((final e) => e.toJson()).toList(),
    'total': total,
    'skip': skip,
    'limit': limit,
  };
}

class Products {
  Products({
    this.id,
    this.title,
    this.description,
    this.category,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    this.images,
    this.thumbnail,
  });

  factory Products.fromJson(final Map<String, dynamic> json) => Products(
    id: json['id'] as int?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    category: json['category'] as String?,
    price: (json['price'] as num?)?.toDouble(),
    discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
    rating: (json['rating'] as num?)?.toDouble(),
    stock: json['stock'] as int?,
    tags: json['tags'] != null
        ? (json['tags'] as List<dynamic>).map((final e) => e as String).toList()
        : null,
    brand: json['brand'] as String?,
    sku: json['sku'] as String?,
    weight: json['weight'] as int?,
    dimensions: json['dimensions'] != null
        ? Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>)
        : null,
    warrantyInformation: json['warrantyInformation'] as String?,
    shippingInformation: json['shippingInformation'] as String?,
    availabilityStatus: json['availabilityStatus'] as String?,
    reviews: json['reviews'] != null
        ? (json['reviews'] as List<dynamic>)
              .map((final e) => Reviews.fromJson(e as Map<String, dynamic>))
              .toList()
        : null,
    returnPolicy: json['returnPolicy'] as String?,
    minimumOrderQuantity: json['minimumOrderQuantity'] as int?,
    meta: json['meta'] != null
        ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
        : null,
    images: json['images'] != null
        ? (json['images'] as List<dynamic>)
              .map((final e) => e as String)
              .toList()
        : null,
    thumbnail: json['thumbnail'] as String?,
  );

  final int? id;
  final String? title;
  final String? description;
  final String? category;
  final double? price;
  final double? discountPercentage;
  final double? rating;
  final int? stock;
  final List<String>? tags;
  final String? brand;
  final String? sku;
  final int? weight;
  final Dimensions? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<Reviews>? reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final Meta? meta;
  final List<String>? images;
  final String? thumbnail;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'discountPercentage': discountPercentage,
    'rating': rating,
    'stock': stock,
    'tags': tags,
    'brand': brand,
    'sku': sku,
    'weight': weight,
    'dimensions': dimensions?.toJson(),
    'warrantyInformation': warrantyInformation,
    'shippingInformation': shippingInformation,
    'availabilityStatus': availabilityStatus,
    'reviews': reviews?.map((final e) => e.toJson()).toList(),
    'returnPolicy': returnPolicy,
    'minimumOrderQuantity': minimumOrderQuantity,
    'meta': meta?.toJson(),
    'images': images,
    'thumbnail': thumbnail,
  };
}

class Dimensions {
  Dimensions({this.width, this.height, this.depth});

  factory Dimensions.fromJson(final Map<String, dynamic> json) => Dimensions(
    width: (json['width'] as num?)?.toDouble(),
    height: (json['height'] as num?)?.toDouble(),
    depth: (json['depth'] as num?)?.toDouble(),
  );

  final double? width;
  final double? height;
  final double? depth;

  Map<String, dynamic> toJson() => {
    'width': width,
    'height': height,
    'depth': depth,
  };
}

class Reviews {
  Reviews({
    this.rating,
    this.comment,
    this.date,
    this.reviewerName,
    this.reviewerEmail,
  });

  factory Reviews.fromJson(final Map<String, dynamic> json) => Reviews(
    rating: json['rating'] as int?,
    comment: json['comment'] as String?,
    date: json['date'] as String?,
    reviewerName: json['reviewerName'] as String?,
    reviewerEmail: json['reviewerEmail'] as String?,
  );

  final int? rating;
  final String? comment;
  final String? date;
  final String? reviewerName;
  final String? reviewerEmail;

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'comment': comment,
    'date': date,
    'reviewerName': reviewerName,
    'reviewerEmail': reviewerEmail,
  };
}

class Meta {
  Meta({this.createdAt, this.updatedAt, this.barcode, this.qrCode});

  factory Meta.fromJson(final Map<String, dynamic> json) => Meta(
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
    barcode: json['barcode'] as String?,
    qrCode: json['qrCode'] as String?,
  );

  final String? createdAt;
  final String? updatedAt;
  final String? barcode;
  final String? qrCode;

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'barcode': barcode,
    'qrCode': qrCode,
  };
}
