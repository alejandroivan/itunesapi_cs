//
//  SearchModels.swift
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

enum Search {
    // MARK: Use cases

    struct Request {
        let searchTerm: String
    }

    struct Response {}

    struct ViewModel {
        let medias: [Media]
    }
}
