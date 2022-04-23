//
//  Art_ObjectsTests.swift
//  Art ObjectsTests
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//

import XCTest
@testable import Art_Objects

class Art_ObjectsTests: XCTestCase {
    
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchingFirstPageOfArtObjects() {
        
        expectation = expectation(description: "Testing async load Art objects for 4 times")
        expectation.expectedFulfillmentCount = 1
        
        let artObjectsService = ArtObjectsService_mock(apiKey: Constants.apiKey,
                                                       culture: Culture.en)
        artObjectsService.maxArtsObjectsCount = 45
        let interactor = ArtsInteractor_mock(artObjectsService: artObjectsService)
        let vc = ArtsViewController(interactor: interactor)
        
        //1
        fetchNextArts(viewController: vc)
        
        waitForExpectations(timeout: 60) { (error) in
            if let error = error {
                XCTFail("WaitForExpectationsWithTimeout errored: \(error)")
            }

            XCTAssertEqual(interactor.artsCount, 20, "Objects count not valid")
            XCTAssertEqual(interactor.currentArtsPageValue, 1, "Objects count not valid")
        }
    }
    
    func testFetchingAllArtObjects() {
        
        expectation = expectation(description: "Testing async load Art objects for 4 times")
        expectation.expectedFulfillmentCount = 4
        
        let artObjectsService = ArtObjectsService_mock(apiKey: Constants.apiKey,
                                                       culture: Culture.en)
        artObjectsService.maxArtsObjectsCount = 45
        let interactor = ArtsInteractor_mock(artObjectsService: artObjectsService)
        let vc = ArtsViewController(interactor: interactor)
        
        //1
        fetchNextArts(viewController: vc)
        
        //2
        fetchNextArts(viewController: vc)

        //3
        fetchNextArts(viewController: vc)
        
        //4
        fetchNextArts(viewController: vc)
        
        waitForExpectations(timeout: 60) { (error) in
            if let error = error {
                XCTFail("WaitForExpectationsWithTimeout errored: \(error)")
            }

            XCTAssertEqual(interactor.artsCount, 45, "Objects count not valid")
            XCTAssertEqual(interactor.currentArtsPageValue, 3, "Objects count not valid")
        }
    }
    
    func fetchNextArts(viewController: ArtsViewController) {
        viewController.interactor.fetchNextArts { [weak self] (success) in
            guard let self = self else { return }
            self.expectation.fulfill()
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
