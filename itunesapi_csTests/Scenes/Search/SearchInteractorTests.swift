//
//  SearchInteractorTests.swift
//  itunesapi_cs
//
//  Created by Alejandro Melo Domínguez on 7/27/19.
//  Copyright (c) 2019 Alejandro Melo Domínguez. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import itunesapi_cs
import XCTest

class SearchInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: SearchInteractor!

    var presenterSpy: SearchPresentationLogicSpy? {
        return sut.presenter as? SearchPresentationLogicSpy
    }

    var workerSpy: SearchWorkerSpy? {
        return sut.worker as? SearchWorkerSpy
    }

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupSearchInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupSearchInteractor() {
        sut = SearchInteractor()
        sut.presenter = SearchPresentationLogicSpy()
        sut.worker = SearchWorkerSpy()
    }

    // MARK: Tests
    func testSearchStarted() {
        // Given
        let request = Search.Request(searchTerm: "test album", page: 1)

        // When
        sut.startSearch(request: request)

        // Then
        XCTAssertTrue(workerSpy!.fetchMediaCalled)
        XCTAssertTrue(presenterSpy!.displayResultsCalled)
    }

    func testSearchCoreData() {
        // Given
        let request = Search.Request(searchTerm: "test album", page: 1)
        let workerSpy = SearchCoreDataWorkerSpy()
        sut.coreDataWorker = workerSpy

        // When
        sut.startSearch(request: request, localResultsOnly: true)

        // Then
        XCTAssertTrue(workerSpy.fetchLocalResultsCalled)
    }

    func testNextPage() {
        // Given
        let request = Search.Request(searchTerm: "test album", page: 2)
        let workerSpy = SearchWorkerSpy()
        let presenterSpy = SearchPresentationLogicSpy()

        sut.worker = workerSpy
        sut.presenter = presenterSpy

        // When
        sut.nextPage(request: request)

        // Then
        XCTAssertTrue(workerSpy.fetchMediaCalled)
        XCTAssertTrue(presenterSpy.displayResultsCalled)
    }
}
