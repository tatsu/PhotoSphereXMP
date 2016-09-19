# PhotoSphereXMP
A Swift Parser for Photo Sphere XMP metadata that is serialized and embedded inside the photo sphere as described by the [Adobe XMP](http://www.adobe.com/products/xmp.html) standard.

## Requirements

Swift 3.0+ (Xcode 8.0+)

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate PhotoSphereXMP into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'PhotoSphereXMP', '~> 0.9.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate PhotoSphereXMP into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "tatsu/PhotoSphereXMP" ~> 0.9.0
```

Run `carthage update` to build the framework and drag the built `PhotoSphereXMP.framework` into your Xcode project.

## Usage

```swift
import PhotoSphereXMP

    // Create a Parser by URL
    let xmp = PhotoSphereXMP(contentsOf: url) // Return is optional

    // Create a Parser by DATA
    let xmp = PhotoSphereXMP(data: data)

    // Parse the content
    xmp.parse { (elements: [PhotoSphereXMP.GPanoElement: Any]?, error: Error?) -> Void in
      // Check error and do something with the metadata dictionary
    }
```

## References
* [Photo Sphere XMP Metadata](https://developers.google.com/streetview/spherical-metadata)
* [Adobe XMP standard](http://www.adobe.com/devnet/xmp.html)

## License

This library is licensed under MIT. Full license text is available in [LICENSE](LICENSE).
