Cách chạy dự án
- Bước 1 : chạy lệnh ở terminal "fvm install 3.32.7"
- Bước 2 : chạy lệnh ở terminal "fvm use 3.32.7"
(hiện yes/no thì chọn yes)


Thông tin tài khoản fake để so sánh khi đăng nhập:
Mã số thuế: 1111111111
Tài khoản: demo
Mật khẩu: 123456



Cấu trúc thư mục của dự án
lib/
├── core/                     # Cung cấp tiện ích chung (network, hive, constants)
│   ├── network/
│   │   ├── dio_client.dart   # config Dio, interceptor thêm token
│   ├── hive/
│   │   ├── hive_service.dart # init, box mở sẵn token, cache
│   ├── utils/
│   │   └── validators.dart   # validate form
│   └── constants.dart        # các key, endpoint
│
├── data/                     # Data layer
│   ├── models/               # JSON⇄Dart object
│   │   ├── user_model.dart
│   │   └── product_model.dart
│   ├── datasources/          # Gọi API qua Dio
│   │   ├── auth_remote.dart
│   │   └── product_remote.dart
│   └── repositories/         # Triển khai interface domain
│       ├── auth_repository_impl.dart
│       └── product_repository_impl.dart
│
├── domain/                   # Business logic thuần
│   ├── entities/             # Định nghĩa các Entity
│   │   ├── user.dart
│   │   └── product.dart
│   ├── repositories/         # Interface repository
│   │   ├── auth_repository.dart
│   │   └── product_repository.dart
│   └── usecases/             # Các hành động (login, getList,…)
│       ├── login_usecase.dart
│       ├── fetch_products.dart
│       └── fetch_product_detail.dart
│
└── presentation/             # UI layer (MVVM)
    ├── viewmodels/           # ViewModel = Cubit / BLoC
    │   ├── login/            # dùng BLoC (events/states)
    │   │   ├── login_bloc.dart
    │   │   ├── login_event.dart
    │   │   └── login_state.dart
    │   ├── product_list/     # Cubit
    │   │   └── product_list_cubit.dart
    │   ├── product_detail/   # Cubit
    │   │   └── product_detail_cubit.dart
    │   └── product_form/     # Cubit cho tạo/sửa
    │       └── product_form_cubit.dart
    │
    ├── views/                # Các màn hình
    │   ├── login_page.dart
    │   ├── product_list_page.dart
    │   ├── product_detail_page.dart
    │   └── product_form_page.dart
    │
    └── widgets/              # Component tái sử dụng
        ├── loading_indicator.dart
        └── product_item.dart
