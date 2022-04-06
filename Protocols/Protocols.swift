//
//  Protocols.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 1.04.2022.
//

import Foundation

//MARK: - MASTER: MainMovieFeedTableViewCell, DELEGATE: MainTabBarController
//On the MainTabBarController, provides navigation to MovieDetailViewController
protocol NavigationProtocol {
    func moveToDetailVC(movie: Movies)
}


//MARK: - MASTER: SearchViewCell, DELEGATE: DiscoverViewController
//When detail or similar buttons clicked, navigates and builds SearchDetailViewController
protocol FeatureButtonsProtocol {
    func userDidRequestWatchList(atRow: Int)
    func userDidRequestDetails(atRow: Int)
    func userDidRequestSimilar(atRow: Int)
}


//Allows user to save movies in userdefaults
protocol WatchlistProtocol {
    func handleWatchlist(movie: Movies)
}

//MARK: - MASTER: DetailTableViewCell, DELEGATE:
protocol DetailScreenButtonProtocol {
    func userDidRequestWatchList()
}
