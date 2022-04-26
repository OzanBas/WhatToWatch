//
//  DataService.swift
//  WhatToWatch?
//
//  Created by Ozan Bas on 7.03.2022.
//

import Foundation
import UIKit

//MARK: - Request

//Request's are done with URLSession extension .request method.

public class DataService {
    
    
    
    
    
    
    //data fetch
    func fetchUpcoming(url:  URL?, tabBarVC : MainTabBarController){
        URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    tabBarVC.upcomingMovies = model.results
                    tabBarVC.mainMovieTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchPopular(url:  URL?, tabBarVC: MainTabBarController) {
        URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    tabBarVC.popularMovies = model.results
                    tabBarVC.mainMovieTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchTopRated(url:  URL?, tabBarVC: MainTabBarController) {
        URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    tabBarVC.topRatedMovies = model.results
                    tabBarVC.mainMovieTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchSimilars(discoverVC: DiscoverViewController, atRow: Int, showVC: SearchDetailViewController, completion: @escaping () -> Void ) {
        if let id = discoverVC.movie[atRow].id {
            let url = Endpoints().urlSimilar(toMovie: String(id))
            URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        discoverVC.similarMovies = model.results
                        discoverVC.discoverTableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
    func fetchSingleMovie(url:  URL?, discoverVC: DiscoverViewController) {
        URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    discoverVC.movie = model.results
                    discoverVC.discoverTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchSingleMovieWL(url:  URL?, watchlistVC: MyWatchlistController) {
        URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    watchlistVC.similarMovies = model.results
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchSimilarsWL(watchlistVC: MyWatchlistController, atRow: Int, showVC: SearchDetailViewController, completion: @escaping () -> Void ) {
        if let id = watchlistVC.movieList[atRow].id {
            let url = Endpoints().urlSimilar(toMovie: String(id))
            URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        watchlistVC.similarMovies = model.results
                    }
                    
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
    func fetchCredits(url:  URL?, DetailVC : MovieDetailViewController){
        URLSession.shared.request(url: url, expecting: CreditsModel.self) { result in
            switch result {
            case .success(let model):
                DetailVC.movieCast = model.cast

            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchCreditsDetail(url:  URL?, DetailVC : SearchDetailViewController){
        URLSession.shared.request(url: url, expecting: CreditsModel.self) { result in
            switch result {
            case .success(let model):
                DetailVC.movieCast = model.cast

            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}

