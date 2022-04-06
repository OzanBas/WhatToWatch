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
    var similarMovies : [Movies] = []
    var watchlistDelegate : WatchlistProtocol?
    var watchlistVC = MyWatchlistController()
    var DM = DataManagement()
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        configureTableView()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
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
    
    func similarApiCall(atRow: Int, showVC: SearchDetailViewController, completion: @escaping () -> Void ) {
        if let id = movie[atRow].id {
            let url = Endpoints().urlSimilar(toMovie: String(id))
            URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        self.similarMovies = model.results
                        print(self.similarMovies.count)
                    }
                    
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
}

//MARK: - TABLEVIEW EXTENSION
extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell
//      SearchViewCell delegate
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
        searchTextField.resignFirstResponder()
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


//MARK: - FEATURE BUTTONS PROTOCOL
extension DiscoverViewController: FeatureButtonsProtocol {
    func userDidRequestWatchList(atRow: Int) {
        let selectedMovie = movie[atRow]
        DM.handleFavorites(movie: selectedMovie)
        
    }
    
    
    func userDidRequestDetails(atRow: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailViewController
        
        nextViewController.movieData = movie[atRow]
        nextViewController.buildType = .buildForDetail
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    func userDidRequestSimilar(atRow: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailViewController
        similarApiCall(atRow: atRow, showVC: nextViewController) {
            DispatchQueue.main.async {
                nextViewController.similarMovies = self.similarMovies
                nextViewController.buildType = .buildForSimilar
                self.navigationController?.pushViewController(nextViewController, animated: true)

            }
        }

    }
    
}
