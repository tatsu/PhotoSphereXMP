//
//  PhotoSphereXMP.swift
//  PhotoSphereXMP
//
//  Created by Tatsuhiko Arai on 9/18/16.
//  Copyright © 2016 Tatsuhiko Arai. All rights reserved.
//

import Foundation

open class PhotoSphereXMP: NSObject, XMLParserDelegate {

    public enum GPanoElement: String {
        case UsePanoramaViewer            = "GPano:UsePanoramaViewer"
        case CaptureSoftware              = "GPano:CaptureSoftware"
        case StitchingSoftware            = "GPano:StitchingSoftware"
        case ProjectionType               = "GPano:ProjectionType"
        case PoseHeadingDegrees           = "GPano:PoseHeadingDegrees"
        case PosePitchDegrees             = "GPano:PosePitchDegrees"
        case PoseRollDegrees              = "GPano:PoseRollDegrees"
        case InitialViewHeadingDegrees    = "GPano:InitialViewHeadingDegrees"
        case InitialViewPitchDegrees      = "GPano:InitialViewPitchDegrees"
        case InitialViewRollDegrees       = "GPano:InitialViewRollDegrees"
        case InitialHorizontalFOVDegrees  = "GPano:InitialHorizontalFOVDegrees"
        case FirstPhotoDate               = "GPano:FirstPhotoDate"
        case LastPhotoDate                = "GPano:LastPhotoDate"
        case SourcePhotosCount            = "GPano:SourcePhotosCount"
        case ExposureLockUsed             = "GPano:ExposureLockUsed"
        case CroppedAreaImageWidthPixels  = "GPano:CroppedAreaImageWidthPixels"
        case CroppedAreaImageHeightPixels = "GPano:CroppedAreaImageHeightPixels"
        case FullPanoWidthPixels          = "GPano:FullPanoWidthPixels"
        case FullPanoHeightPixels         = "GPano:FullPanoHeightPixels"
        case CroppedAreaLeftPixels        = "GPano:CroppedAreaLeftPixels"
        case CroppedAreaTopPixels         = "GPano:CroppedAreaTopPixels"
        case InitialCameraDolly           = "GPano:InitialCameraDolly"
    }

    let parser: XMPParser
    var completionHandler: (([GPanoElement: Any]?, Error?) -> Void)!

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

    open func parse(completionHandler: @escaping (([GPanoElement: Any]?, Error?) -> Void)) {
        self.completionHandler = completionHandler
        parser.parse()
    }

    // MARK: - XMLParserDelegate methods

    var elements: [GPanoElement: Any]!
    var parsingElement: GPanoElement?
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
        parsingElement = GPanoElement(rawValue: elementName)
        if let element = parsingElement {
            switch element {
            // Boolean
            case .UsePanoramaViewer:
                fallthrough
            case .ExposureLockUsed:
                foundHandler = { self.elements[element] = $0 == "True" ? true : false }

            // String
            case .CaptureSoftware:
                fallthrough
            case .StitchingSoftware:
                fallthrough
            case .ProjectionType:
                foundHandler = { self.elements[element] = $0 }

            // Real
            case .PoseHeadingDegrees:
                fallthrough
            case .PosePitchDegrees:
                fallthrough
            case .PoseRollDegrees:
                fallthrough
            case .InitialHorizontalFOVDegrees:
                fallthrough
            case .InitialCameraDolly:
                foundHandler = { self.elements[element] = Double($0) ?? 0.0 }

            // Integer
            case .InitialViewHeadingDegrees:
                fallthrough
            case .InitialViewPitchDegrees:
                fallthrough
            case .InitialViewRollDegrees:
                fallthrough
            case .SourcePhotosCount:
                fallthrough
            case .CroppedAreaImageWidthPixels:
                fallthrough
            case .CroppedAreaImageHeightPixels:
                fallthrough
            case .FullPanoWidthPixels:
                fallthrough
            case .FullPanoHeightPixels:
                fallthrough
            case .CroppedAreaLeftPixels:
                fallthrough
            case .CroppedAreaTopPixels:
                foundHandler = { self.elements[element] = Int($0) ?? 0 }

            // Date
            case .FirstPhotoDate:
                fallthrough
            case .LastPhotoDate:
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
