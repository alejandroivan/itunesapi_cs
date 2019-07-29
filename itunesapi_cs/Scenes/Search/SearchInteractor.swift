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
}

protocol SearchDataStore {
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore {
    var presenter: SearchPresentationLogic?
    var worker: SearchWorker? = SearchWorker()
    var coreDataWorker: SearchCoreDataWorker? = SearchCoreDataWorker()

    func startSearch(request: Search.Request) {
        startSearch(request: request, localResultsOnly: false)
    }

    func startSearch(request: Search.Request, localResultsOnly: Bool) {
        if localResultsOnly {
            let medias = coreDataWorker?.fetchLocalResults(for: request.searchTerm) ?? []
            let response = Search.Response(medias: medias)
            presenter?.displayResults(response: response)
        } else {
            worker?.fetchMedia(
                for: request.searchTerm,
                page: 1,
                completion: { (success, medias) in
                    let response = Search.Response(medias: medias)
                    self.presenter?.displayResults(response: response)
                }
            )
        }
    }
}
