[![](https://github.com/powerwolf543/RxSwiftPlayground/workflows/UnitTests/badge.svg)](https://github.com/powerwolf543/RxSwiftPlayground/actions?query=workflow%3AUnitTests) 
[![codecov](https://codecov.io/gh/powerwolf543/RxSwiftPlayground/branch/master/graph/badge.svg)](https://codecov.io/gh/powerwolf543/RxSwiftPlayground)

# RxSwiftPlayground
An iOS project that is practiced with `RxSwift`

## Modules

### Networking

A simple `URLSession` wrapper that is implemented with `RxSwift`.

The protocol of `NetworkRequest` makes you define the HTTP request easily and could be converted to a `URLRequest`.

The class of `HTTPClient` helps to create the connection from a request which conforms the `NetworkRequest`. It would decode the response automatically as the `NetworkRequest.Response` after received the network callback.

**Usage:**

``` swift
let observable = HTTPClient().fetchDataModel(request: SomeRequest())
```

### ImageLoader

A simple image loader that contains the functions of download and cache images. You could easily pass a `URL` to retrieve the image. The caching would store the data to the memory and disk. The image loader is implemented with `RxSwift`.

**Usage:**

``` swift
ImageLoader().retrieveImage(with: url).bind(to: imageView.rx.image)
```

## Requirements

- Xcode 11.7
- Swift 5.2

## Author

Nixon Shih, powerwolf543@gmail.com

## License

RxSwiftPlayground is available under the MIT license. See the LICENSE file for more info.
