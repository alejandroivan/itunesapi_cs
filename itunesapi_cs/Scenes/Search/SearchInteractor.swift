//
//  SearchInteractor.swift
//  itunesapi_cs
//
//  Created by Alejandro Melo Domínguez on 7/27/19.
//  Copyright (c) 2019 Alejandro Melo Domínguez. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchBusinessLogic {
    func startSearch(request: Search.Request)
    func startSearch(request: Search.Request, localResultsOnly: Bool)

    func nextPage(request: Search.Request)
    func didSelectMedia(request: Search.DetailsRequest)
}

protocol SearchDataStore {
    var lastTerm: String { get set }
    var currentPage: Int { get set }
    var currentMedias: [Media] { get set }
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore {
    var presenter: SearchPresentationLogic?
    var worker: SearchWorker? = SearchWorker()
    var coreDataWorker: SearchCoreDataWorker? = SearchCoreDataWorker()

    // MARK: - Data Store
    var lastTerm: String = ""
    var currentPage: Int = 1
    var currentMedias: [Media] = []

    // MARK: - Business logic

    func startSearch(request: Search.Request) {
        startSearch(request: request, localResultsOnly: false)
    }

    func startSearch(request: Search.Request, localResultsOnly: Bool) {
        currentMedias = []
        currentPage = request.page
        lastTerm = request.searchTerm

        if localResultsOnly {
            let medias = coreDataWorker?.fetchLocalResults(for: request.searchTerm) ?? []
            let response = Search.Response(medias: medias)

            currentMedias = medias
            presenter?.displayResults(response: response)
        } else {
            presenter?.displayLoadingIndicator()

            worker?.fetchMedia(
                for: request.searchTerm,
                page: request.page,
                completion: { (success, medias) in
                    self.presenter?.dismissLoadingIndicator()
                    
                    if success {
                        self.currentMedias = medias
                        let response = Search.Response(medias: medias)

                        self.coreDataWorker?.saveLocalResults(for: request.searchTerm, medias: response.medias)
                        self.presenter?.displayResults(response: response)
                    } else {
                        self.startSearch(request: request, localResultsOnly: true)
                    }
                }
            )
        }
    }

    func nextPage(request: Search.Request) {
        guard request.searchTerm == lastTerm else {
            let newSearchRequest = Search.Request(searchTerm: request.searchTerm, page: 1)
            startSearch(request: newSearchRequest)
            return
        }

        currentPage += 1
        lastTerm = request.searchTerm

        worker?.fetchMedia(
            for: request.searchTerm,
            page: request.page,
            completion: { (success, medias) in
                let filtered = medias.filter { $0.collectionId != nil && $0.kind != nil && $0.kind! == "song" }
                self.currentMedias.append(contentsOf: filtered)
                let response = Search.Response(medias: self.currentMedias)

                self.coreDataWorker?.saveLocalResults(for: request.searchTerm, medias: response.medias)
                self.presenter?.displayResults(response: response)
            }
        )
    }

    func didSelectMedia(request: Search.DetailsRequest) {
        let response = Search.DetailsResponse(media: request.media)
        presenter?.displayMediaDetails(response: response)
    }
}
