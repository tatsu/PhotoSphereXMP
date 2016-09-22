//
//  PhotoSphereXMP.swift
//  PhotoSphereXMP
//
//  Created by Tatsuhiko Arai on 9/18/16.
//  Copyright © 2016 Tatsuhiko Arai. All rights reserved.
//

import Foundation

open class PhotoSphereXMP: NSObject, XMLParserDelegate {

    public enum GPano: String {
        case usePanoramaViewer            = "GPano:UsePanoramaViewer"
        case captureSoftware              = "GPano:CaptureSoftware"
        case stitchingSoftware            = "GPano:StitchingSoftware"
        case projectionType               = "GPano:ProjectionType"
        case poseHeadingDegrees           = "GPano:PoseHeadingDegrees"
        case posePitchDegrees             = "GPano:PosePitchDegrees"
        case poseRollDegrees              = "GPano:PoseRollDegrees"
        case initialViewHeadingDegrees    = "GPano:InitialViewHeadingDegrees"
        case initialViewPitchDegrees      = "GPano:InitialViewPitchDegrees"
        case initialViewRollDegrees       = "GPano:InitialViewRollDegrees"
        case initialHorizontalFOVDegrees  = "GPano:InitialHorizontalFOVDegrees"
        case firstPhotoDate               = "GPano:FirstPhotoDate"
        case lastPhotoDate                = "GPano:LastPhotoDate"
        case sourcePhotosCount            = "GPano:SourcePhotosCount"
        case exposureLockUsed             = "GPano:ExposureLockUsed"
        case croppedAreaImageWidthPixels  = "GPano:CroppedAreaImageWidthPixels"
        case croppedAreaImageHeightPixels = "GPano:CroppedAreaImageHeightPixels"
        case fullPanoWidthPixels          = "GPano:FullPanoWidthPixels"
        case fullPanoHeightPixels         = "GPano:FullPanoHeightPixels"
        case croppedAreaLeftPixels        = "GPano:CroppedAreaLeftPixels"
        case croppedAreaTopPixels         = "GPano:CroppedAreaTopPixels"
        case initialCameraDolly           = "GPano:InitialCameraDolly"
    }

    let parser: XMPParser
    var completionHandler: (([GPano: Any]?, Error?) -> Void)!

    public init?(contentsOf url: URL) {
        guard let parser = XMPParser(contentsOf: url) else {
            return nil
        }

        self.parser = parser

        super.init()

        parser.delegate = self
    }
    
    public init(data: Data) {
        parser = XMPParser(data: data)

        super.init()

        parser.delegate = self
    }

    open func parse(completionHandler: @escaping (([GPano: Any]?, Error?) -> Void)) {
        self.completionHandler = completionHandler
        parser.parse()
    }

    // MARK: - XMLParserDelegate methods

    var elements: [GPano: Any]!
    var parsingElement: GPano?
    var foundHandler: ((String) -> Void)!

    public func parserDidStartDocument(_ parser: XMLParser) {
        elements = [:]
        parsingElement = nil
        foundHandler = nil
    }

    public func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler(elements, nil)
        elements = nil
        parsingElement = nil
        foundHandler = nil
    }

    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completionHandler(elements, parseError)
        elements = nil
        parsingElement = nil
        foundHandler = nil
    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        parsingElement = GPano(rawValue: elementName)
        if let element = parsingElement {
            switch element {
            // Boolean
            case .usePanoramaViewer:            fallthrough
            case .exposureLockUsed:
                foundHandler = { self.elements[element] = $0 == "True" ? true : false }

            // String
            case .captureSoftware:              fallthrough
            case .stitchingSoftware:            fallthrough
            case .projectionType:
                foundHandler = { self.elements[element] = $0 }

            // Real
            case .poseHeadingDegrees:           fallthrough
            case .posePitchDegrees:             fallthrough
            case .poseRollDegrees:              fallthrough
            case .initialHorizontalFOVDegrees:  fallthrough
            case .initialCameraDolly:
                foundHandler = { self.elements[element] = Double($0) ?? 0.0 }

            // Integer
            case .initialViewHeadingDegrees:    fallthrough
            case .initialViewPitchDegrees:      fallthrough
            case .initialViewRollDegrees:       fallthrough
            case .sourcePhotosCount:            fallthrough
            case .croppedAreaImageWidthPixels:  fallthrough
            case .croppedAreaImageHeightPixels: fallthrough
            case .fullPanoWidthPixels:          fallthrough
            case .fullPanoHeightPixels:         fallthrough
            case .croppedAreaLeftPixels:        fallthrough
            case .croppedAreaTopPixels:
                foundHandler = { self.elements[element] = Int($0) ?? 0 }

            // Date
            case .firstPhotoDate:               fallthrough
            case .lastPhotoDate:
                foundHandler = { string in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = formatter.date(from: string)
                    self.elements[element] = date ?? string
                }
            }
        }
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let handler = foundHandler {
            handler(string)
            parsingElement = nil
            foundHandler = nil
        }
    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // no op
    }

}
