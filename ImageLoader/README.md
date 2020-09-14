# ImageLoader

A simple image loader that contains the functions of download and cache images. You could easily pass a `URL` to retrieve the image. The caching would store the data to the memory and disk. The image loader is implemented with `RxSwift`.

**Usage:**

``` swift
ImageLoader().retrieveImage(with: url).bind(to: imageView.rx.image)
```
