//
//  BaseTests.swift
//  Spartan
//
//  Created by Dalton Hinterscher on 1/21/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest

class BaseTests: XCTestCase {
    
    internal var validationExpectation: XCTestExpectation!
    
    internal let ALBUM_ID = "0sNOF9WDwhWunNAHPD3Baj"
    internal let ARTIST_ID = "0OdUWJ0sBjDrqHygGUXeCF"
    internal let TRACK_ID = "3TwtrR1yNLY1PMPsrGQpOp"
    internal let SEARCH_TERM = "Five For Fighting"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        validationExpectation = expectation(description: "Validation")
    }
    
    func waitForRequestToFinish(){
        
        waitForExpectations(timeout: 60.0) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
}
