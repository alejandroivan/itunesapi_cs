//
//  MediaPlayerInteractor.swift
//  itunesapi_cs
//
//  Created by Alejandro Melo Domínguez on 7/29/19.
//  Copyright (c) 2019 Alejandro Melo Domínguez. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MediaPlayerBusinessLogic {
    func loaded()
    func playMedia(request: MediaPlayer.PlayRequest)
}

protocol MediaPlayerDataStore {
    var media: Media? { get set }
}

class MediaPlayerInteractor: MediaPlayerBusinessLogic, MediaPlayerDataStore {
    var presenter: MediaPlayerPresentationLogic?
    var worker: MediaPlayerWorker?
    var media: Media?

    func loaded() {
        
    }

    func playMedia(request: MediaPlayer.PlayRequest) {
        let response = MediaPlayer.PlayResponse(media: request.media)
        presenter?.presentPlaybackStatus(response: response)
    }
}
