//
//  MyWatchlistController.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 29.03.2022.
//

import UIKit

protocol WatchlistProtocol {
    func handleWatchlist(movie: Movies)
}


class MyWatchlistController: UIViewController {
    
    //MARK: - PROPERTIES
    
    @IBOutlet weak var watchlistTableView: UITableView!
    
    var movieList : [Movies] = []
    
    var savedMovieList : [Movies] = [] {
        didSet{
//            movieList = Array(Set(savedMovieList))
            storeData(movies: movieList)
            print(movieList.count)
            movieList = savedMovieList
        }
    }
    
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveData()

        watchlistTableView.reloadData()
    }
    
    
    //MARK: - HELPERS
    
    func configureTableView() {
        watchlistTableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: "SearchViewCell")
        watchlistTableView.rowHeight = 200
    }


    func storeData(movies: [Movies]?) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(movies)
            UserDefaults.standard.set(data, forKey: "movies")
        } catch {
            print("UserDefaults Encode error:  \(error)")
        }
    }
    
    func retrieveData() {
        if let data = UserDefaults.standard.data(forKey: "movies") {
            do {
                let decoder = JSONDecoder()
                let retrievedData = try decoder.decode([Movies].self, from: data)
                self.movieList = retrievedData
            } catch {
                print("UserDefaults Unable to retrieve data: \(error)")
            }
        }
    }
}
//MARK: - TABLEVIEW EXTENSION

extension MyWatchlistController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell
        
        cell.detailsButton.row = indexPath.row
        cell.similarMoviesButton.row = indexPath.row
        cell.watchListButton.row = indexPath.row
        
        cell.releaseLabel.displayStringOptional(string: movieList[indexPath.row].release_date, headline: "Release: ")
        cell.titleLabel.displayStringOptional(string: movieList[indexPath.row].original_title, headline: "Title: ")
        cell.scoreLabel.displayFloatOptional(float: movieList[indexPath.row].vote_average, headline: "Score: ")
        if let posterPath = movieList[indexPath.row].poster_path {
            cell.coverImage.setCoverImage(posterPath: posterPath)
        }
        
        
        return cell
    }
}
//MARK: - WATCHLIST PROTOCOL
//MARK: - bunun daha güzel bi yolu var mı sor
extension MyWatchlistController: WatchlistProtocol {
    
    func handleWatchlist(movie: Movies) {
        
        if let index = savedMovieList.firstIndex(of: movie) {
            savedMovieList.remove(at: index)
        } else {
            self.savedMovieList.append(movie)
        }
    }
    
}
