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

> At the time of writing, --pre option is a must for Xcode 8.

To integrate PhotoSphereXMP into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'PhotoSphereXMP', '~> 1.0.0'
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
github "tatsu/PhotoSphereXMP" ~> 1.0.0
```

Run `carthage update` to build the framework and drag the built `PhotoSphereXMP.framework` into your Xcode project.

## Usage

### Sample code

```swift
import PhotoSphereXMP

    // Create a Parser by URL
    let xmp = PhotoSphereXMP(contentsOf: url) // Return is optional

    // Create a Parser by DATA
    let xmp = PhotoSphereXMP(data: data)

    // Parse the content
    xmp.parse { (elements: [PhotoSphereXMP.GPano: Any]?, error: Error?) -> Void in
      // Check error and do something with the metadata dictionary
    }
```

### Metadata properties

| Name | Type | GPano enum case name | Swift type |
|------|------|-----------------|------------|
|GPano:UsePanoramaViewer|Boolean|usePanoramaViewer|Bool|
|GPano:CaptureSoftware|String|captureSoftware|String|
|GPano:StitchingSoftware|String|stitchingSoftware|String|
|GPano:ProjectionType|Open Choice of Text|projectionType|String|
|GPano:PoseHeadingDegrees|Real|poseHeadingDegrees|Double|
|GPano:PosePitchDegrees|Real|posePitchDegrees|Double|
|GPano:PoseRollDegrees|Real|poseRollDegrees|Double|
|GPano:InitialViewHeadingDegrees|Integer|initialViewHeadingDegrees|Int|
|GPano:InitialViewPitchDegrees|Integer|initialViewPitchDegrees|Int|
|GPano:InitialViewRollDegrees|Integer|initialViewRollDegrees|Int|
|GPano:InitialHorizontalFOVDegrees|Real|initialHorizontalFOVDegrees|Double|
|GPano:FirstPhotoDate|Date|firstPhotoDate|Date|
|GPano:LastPhotoDate|Date|lastPhotoDate|Date|
|GPano:SourcePhotosCount|Integer|sourcePhotosCount|Int|
|GPano:ExposureLockUsed|Boolean|exposureLockUsed|Bool|
|GPano:CroppedAreaImageWidthPixels|Integer|croppedAreaImageWidthPixels|Int|
|GPano:CroppedAreaImageHeightPixels|Integer|croppedAreaImageHeightPixels|Int|
|GPano:FullPanoWidthPixels|Integer|fullPanoWidthPixels|Int|
|GPano:FullPanoHeightPixels|Integer|fullPanoHeightPixels|Int|
|GPano:CroppedAreaLeftPixels|Integer|croppedAreaLeftPixels|Int|
|GPano:CroppedAreaTopPixels|Integer|croppedAreaTopPixels|Int|
|GPano:InitialCameraDolly|Real|initialCameraDolly|Double|


## References
* [Photo Sphere XMP Metadata](https://developers.google.com/streetview/spherical-metadata)
* [Adobe XMP standard](http://www.adobe.com/devnet/xmp.html)

## License

This library is licensed under MIT. Full license text is available in [LICENSE](LICENSE).
