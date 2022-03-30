//
//  DiscoverViewController.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 21.03.2022.
//

import UIKit

class DiscoverViewController: UIViewController {

    
    
    //MARK: - PROPERTIES
    
    @IBOutlet weak var discoverTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    var movie : [Movies] = []
    var watchlistDelegate : WatchlistProtocol?
    var watchlistVC = MyWatchlistController()
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        configureTableView()
    }
    
    //MARK: - HELPERS
    
//    configure TableView
    func configureTableView() {
        discoverTableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: "SearchViewCell")
        discoverTableView.dataSource = self
        discoverTableView.delegate = self
        discoverTableView.rowHeight = 200
    }
    
    
//MARK: - API CALLS
    func searchMovie(url:  URL?) {
        URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.movie = model.results
                    self.discoverTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchSimilarMovies(atRow: Int, completion: @escaping () -> Void) {
        if let title = movie[atRow].title {
            let correctedTitle = title.replacingOccurrences(of: " ", with: "+")
            let url = Endpoints().urlSimilar(toMovie: correctedTitle)
            searchMovie(url: url)
        }
        completion()
    }
    
}

//MARK: - TABLEVIEW EXTENSION
extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(movie.count)
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell
        cell.delegate = self
        
        cell.detailsButton.row = indexPath.row
        cell.similarMoviesButton.row = indexPath.row
        cell.watchListButton.row = indexPath.row
        
        
        cell.releaseLabel.displayStringOptional(string: movie[indexPath.row].release_date, headline: "Release: ")
        cell.titleLabel.displayStringOptional(string: movie[indexPath.row].original_title, headline: "Title: ")
        cell.scoreLabel.displayFloatOptional(float: movie[indexPath.row].vote_average, headline: "Score: ")
        if let posterPath = movie[indexPath.row].poster_path {
            cell.coverImage.setCoverImage(posterPath: posterPath)
        }
        
        return cell
    }
    
    
}

//MARK: - TEXTFIELD EXTENSION
extension DiscoverViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return searchTextField.endEditing(true)
    }
    
//    CONSTANT SEARCH
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = searchTextField.text {
            let correctedText = text.replacingOccurrences(of: " ", with: "+")
            let url = Endpoints().movieSearch(query: correctedText)
            searchMovie(url: url)
        }
    }
    
}

        
//    SINGLE SEARCH
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        if let text =  searchTextField.text {
//            let correctedText = text.replacingOccurrences(of: " ", with: "+")
//            let url = Endpoints().movieSearch(query: correctedText)
//            searchMovie(url: url)
//        }
//    }
//}

//MARK: - FEATURE BUTTONS EXTENSION
extension DiscoverViewController: FeatureButtonsProtocol {
    func userDidRequestWatchList(atRow: Int) {
        let selectedMovie = movie[atRow]
        watchlistVC.handleWatchlist(movie: selectedMovie)
    }
    
    func userDidRequestDetails(atRow: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailViewController
        
        nextViewController.movieData = movie[atRow]
        nextViewController.buildType = .buildForDetail
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    func userDidRequestSimilar(atRow: Int) {
        
        searchSimilarMovies(atRow: atRow) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailViewController
            nextViewController.similarMovies = self.movie
            nextViewController.buildType = .buildForSimilar
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
}
