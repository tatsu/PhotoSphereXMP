//
//  XMPParser.swift
//  PhotoSphereXMP
//
//  Created by Tatsuhiko Arai on 9/18/16.
//  Copyright © 2016 Tatsuhiko Arai. All rights reserved.
//

import Foundation

let XMPMETA_START = "<x:xmpmeta".data(using: .ascii)!
let XMPMETA_END   = "</x:xmpmeta>".data(using: .ascii)!

open class XMPParser: XMLParser {
    public let xmpmeta: Data

    public convenience init?(contentsOf url: URL) {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        self.init(data: data)
    }

    public override init(data: Data) {
        if let startRange = data.range(of: XMPMETA_START), let endRange = data.range(of: XMPMETA_END, in: Range(uncheckedBounds: (startRange.upperBound, data.count))) {
            let range = Range(uncheckedBounds: (startRange.lowerBound, endRange.upperBound))
            xmpmeta = data.subdata(in: range)
        } else {
            xmpmeta = Data()
        }

        super.init(data: xmpmeta)
    }

}
