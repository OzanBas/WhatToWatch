//
//  MyWatchlistController.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 29.03.2022.
//

import UIKit



class MyWatchlistController: UIViewController {
    
    //MARK: - PROPERTIES
    
    @IBOutlet weak var watchlistTableView: UITableView!
    
    @IBOutlet weak var emptyView: UIView!
    let DM = DataManagement()
    let service = DataService()
    var movieList : [Movies] = [] {
        didSet {
            if self.movieList.count > 0 {
                self.emptyView.isHidden = true
            } else {
                self.emptyView.isHidden = false
            }
        }
    }
    
    var similarMovies : [Movies] = []
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
        refreshMovieList()
        watchlistTableView.reloadData()
    }
    
    
    //MARK: - HELPERS
    
    func refreshMovieList() {
        DM.retrieveData()
        movieList = DM.favoritesList
    }
    
    func configureTableView() {
        watchlistTableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: "SearchViewCell")
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
        watchlistTableView.rowHeight = 200
    }
}

//MARK: - TABLEVIEW EXTENSION

extension MyWatchlistController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell
        cell.delegate = self
        
        cell.detailsButton.row = indexPath.row
        cell.similarMoviesButton.row = indexPath.row
        cell.watchListButton.row = indexPath.row
        
        cell.watchListButton.setImage(UIImage(systemName: "trash"), for: .normal)
        
        let initialMovie = movieList[indexPath.row]
        
        cell.releaseLabel.attributedTextDisplay(headline: "Release: ", info: handleStringOptional(string: initialMovie.release_date))
        cell.titleLabel.attributedTextDisplay(headline: "Title: ", info: handleStringOptional(string: initialMovie.title))
        cell.scoreLabel.attributedTextDisplay(headline: "Score: ", info: handleFloatOptional(float: initialMovie.vote_average))
        cell.genreLabel.attributedTextDisplay(headline: "Genre: ", info: handleStringOptional(string: initialMovie.genres))
        
        if let posterPath = movieList[indexPath.row].poster_path {
            cell.coverImage.setCoverImage(posterPath: posterPath)
        }
        
        return cell
    }
}

//MARK: - FEATURE BUTTONS PROTOCOL EXTENSION
extension MyWatchlistController: FeatureButtonsProtocol {
    func userDidRequestWatchList(atRow: Int) {
        let selectedMovie = movieList[atRow]
        DM.handleFavorites(movie: selectedMovie)
        DispatchQueue.main.async {
            self.refreshMovieList()
            self.watchlistTableView.reloadData()
            print(self.movieList.count)
        }
        
    }
    
    
    func userDidRequestDetails(atRow: Int) {
        
        let storyboard = UIStoryboard(name: "Discover", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailViewController
        
        nextViewController.movieData = movieList[atRow]
        nextViewController.buildType = .buildForDetail
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    func userDidRequestSimilar(atRow: Int) {
        
        let storyboard = UIStoryboard(name: "Discover", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailViewController
        service.fetchSimilarsWL(watchlistVC: self, atRow: atRow, showVC: nextViewController) {
            DispatchQueue.main.async {
                nextViewController.similarMovies = self.similarMovies
                nextViewController.buildType = .buildForSimilar
                self.navigationController?.pushViewController(nextViewController, animated: true)
                
            }
        }
    }
}
