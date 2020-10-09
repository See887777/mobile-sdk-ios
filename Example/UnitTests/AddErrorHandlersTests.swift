//
//  HandlersTests.swift
//  Tests
//
//  Created by Serhii Londar on 12.10.2019.
//  Copyright © 2019 Serhii Londar. All rights reserved.
//

import XCTest
@testable import CrowdinSDK

class AddErrorHandlersTests: XCTestCase {
    override func setUp() {
        super.setUp()
        let crowdinProviderConfig = CrowdinProviderConfig(hashString: "wrong_hash",
                                                          sourceLanguage: "en")
        let crowdinSDKConfig = CrowdinSDKConfig.config().with(crowdinProviderConfig: crowdinProviderConfig)
                                                        .with(enterprise: true)
        CrowdinSDK.startWithConfig(crowdinSDKConfig, completion: { })
    }
    
    
    override func tearDown() {
        CrowdinSDK.removeAllErrorHandlers()
        CrowdinSDK.deintegrate()
        CrowdinSDK.stop()
    }
    
    func testAddErrorHandler() {
        let expectation = XCTestExpectation(description: "Error handler is called")
        let hendlerId = CrowdinSDK.addErrorUpdateHandler {_ in
            XCTAssert(true, "Error handler called")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 60.0)
        
        CrowdinSDK.removeErrorHandler(hendlerId)
    }
}