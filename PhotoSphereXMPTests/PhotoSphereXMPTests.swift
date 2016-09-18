//
//  PhotoSphereXMPTests.swift
//  PhotoSphereXMPTests
//
//  Created by Tatsuhiko Arai on 9/18/16.
//  Copyright © 2016 Tatsuhiko Arai. All rights reserved.
//

import XCTest
@testable import PhotoSphereXMP

class PhotoSphereXMPTests: XCTestCase {
    var url: URL!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let bundle = Bundle(for: type(of: self))
        url = bundle.url(forResource: "IMG_2492", withExtension: "JPG")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParseUrl() {
        let xmp = PhotoSphereXMP(contentsOf: url)
        let semaphore = DispatchSemaphore(value: 0)
        xmp!.parse { elements, error in
            XCTAssertEqual(elements!.count, 11)

            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }

    func testParseData() {
        let data = try! Data(contentsOf: url)
        let xmp = PhotoSphereXMP(data: data)
        let semaphore = DispatchSemaphore(value: 0)
        xmp.parse { elements, error in
            XCTAssertEqual(elements![.ProjectionType] as! String, "equirectangular")
            XCTAssertEqual(elements![.FullPanoHeightPixels] as! Int, 2688)
            XCTAssertEqual(elements![.CroppedAreaTopPixels] as! Int, 0)
            XCTAssertEqual(elements![.CroppedAreaImageHeightPixels] as! Int, 2688)
            XCTAssertEqual(elements![.PoseRollDegrees] as! Double, 0.0)
            XCTAssertEqual(elements![.PoseHeadingDegrees] as! Double, 0.0)
            XCTAssertEqual(elements![.PosePitchDegrees] as! Double, 0.0)
            XCTAssertEqual(elements![.FullPanoWidthPixels] as! Int, 5376)
            XCTAssertEqual(elements![.CroppedAreaImageWidthPixels] as! Int, 5376)
            XCTAssertEqual(elements![.UsePanoramaViewer] as! Bool, true)
            XCTAssertEqual(elements![.CroppedAreaLeftPixels] as! Int, 0)

            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }

    func testPerformanceParseData() {
        let data = try! Data(contentsOf: url)
        let semaphore = DispatchSemaphore(value: 0)
        self.measure {
            let xmp = PhotoSphereXMP(data: data)
            xmp.parse { elements, error in
                semaphore.signal()
            }
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
}
