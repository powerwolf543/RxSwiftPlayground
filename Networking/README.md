# Networking

A simple `URLSession` wrapper that is implemented with `RxSwift`.

The protocol of `NetworkRequest` makes you define the HTTP request easily and could be converted to a `URLRequest`.

The class of `HTTPClient` helps to create the connection from a request which conforms the `NetworkRequest`. It would decode the response automatically as the `NetworkRequest.Response` after received the network callback.

**Usage:**

``` swift
let observable = HTTPClient().fetchDataModel(request: SomeRequest())
```
