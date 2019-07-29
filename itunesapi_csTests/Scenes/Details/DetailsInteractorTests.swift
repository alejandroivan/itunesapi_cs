//
//  DetailsInteractorTests.swift
//  itunesapi_cs
//
//  Created by Alejandro Melo Domínguez on 7/29/19.
//  Copyright (c) 2019 Alejandro Melo Domínguez. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import itunesapi_cs
import XCTest

class DetailsInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: DetailsInteractor!

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupDetailsInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupDetailsInteractor() {
        sut = DetailsInteractor()
    }

    // MARK: Tests

    func testFetchAlbumDetailsSuccess() {
        // Given
        let media = Media(
            wrapperType: "wrapper type",
            artistName: "artist",
            collectionId: 1,
            collectionName: "collection name",
            kind: "kind",
            trackId: 1,
            trackName: "track 1",
            trackNumber: 1,
            artwork: "artwork",
            previewUrl: nil
        )
        let request = Details.Request(media: media)
        let presenterSpy = DetailsPresentationLogicSpy()
        let workerSpy = DetailsWorkerSpy()
        sut.presenter = presenterSpy
        sut.worker = workerSpy

        // When
        sut.fetchAlbumDetails(request: request)

        // Then
        XCTAssertTrue(presenterSpy.presentAlbumDetailsCalled)
    }

    func testFetchAlbumDetailsFailure() {
        // Given
        let media = Media(
            wrapperType: "wrapper type",
            artistName: "artist",
            collectionId: 1,
            collectionName: "collection name",
            kind: "kind",
            trackId: 1,
            trackName: "track 1",
            trackNumber: 1,
            artwork: "artwork",
            previewUrl: nil
        )
        let request = Details.Request(media: media)
        let presenterSpy = DetailsPresentationLogicSpy()
        let workerSpy = DetailsWorkerSpy()
        workerSpy.shouldFailFetchAlbumDetails = true
        sut.presenter = presenterSpy
        sut.worker = workerSpy

        // When
        sut.fetchAlbumDetails(request: request)

        // Then
        XCTAssertFalse(presenterSpy.presentAlbumDetailsCalled)
        XCTAssertTrue(presenterSpy.presentAlbumDetailsErrorMessage)
    }
}
