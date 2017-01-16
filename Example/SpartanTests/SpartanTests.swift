//
//  SpartanTests.swift
//  SpartanTests
//
//  Created by Dalton Hinterscher on 1/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Spartan

class SpartanTests: XCTestCase {
    
    var validationExpectation:XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        validationExpectation = expectation(description: "Validation")
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Album Tests
    
    let ALBUM_ID = "0sNOF9WDwhWunNAHPD3Baj"
    
    func testThatGetAlbumRequestCorrectlyMapsASingleAlbum() {
        
        _ = Spartan.getAlbum(id: ALBUM_ID, success: { (album) in
            self.validationExpectation.fulfill()
            XCTAssert(true)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    func testThatGetAlbumsRequestCorrectlyMapsMultipleAlbums() {
        _ = Spartan.getAlbums(ids: [ALBUM_ID, ALBUM_ID, ALBUM_ID], success: { (albums) in
            self.validationExpectation.fulfill()
            XCTAssert(albums.count == 3)
        }, failure: { (error) in
            self.validationExpectation.fulfill()
            XCTFail(error.errorMessage)
        })
        
        waitForRequestToFinish()
    }
    
    // MARK: Helpers
    
    func waitForRequestToFinish(){
        
        waitForExpectations(timeout: 60.0) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
}
