//
//  DiscoverViewController.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 21.03.2022.
//

import UIKit

class DiscoverViewController: UIViewController {

    
    
    //MARK: - PROPERTIES
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var discoverTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    var similarMovies : [Movies] = []
    var watchlistDelegate : WatchlistProtocol?
    var watchlistVC = MyWatchlistController()
    var DM = DataManagement()
    let service = DataService()
    var movie : [Movies] = [] {
        didSet {
            if movie.count == 0 {
                if searchTextField.hasText == true {
                    alertView.isHidden = false
                    alertLabel.text = "No results."
                }
            } else {
                self.alertView.isHidden = true
            }
        }
    }

    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        configureTableView()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        searchTextField.addTarget(self, action: #selector(actionTextFieldIsEditingChanged), for: UIControl.Event.editingChanged)
        
        alertView.isHidden = false
        alertLabel.text = "Browse movies online."
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DM.retrieveData()
        discoverTableView.reloadData()
    }
    //MARK: - HELPERS
    

    
    
    
//    configure TableView
    func configureTableView() {
        discoverTableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: "SearchViewCell")
        discoverTableView.dataSource = self
        discoverTableView.delegate = self
        discoverTableView.rowHeight = 200
    }
    
}

//MARK: - TABLEVIEW EXTENSION
extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell
        let initialMovie = movie[indexPath.row]

        //SearchViewCell delegate
        cell.delegate = self
        
        cell.detailsButton.row = indexPath.row
        cell.similarMoviesButton.row = indexPath.row
        cell.watchListButton.row = indexPath.row
        
        //WatchlistButtonState
        cell.watchlistButtonStateConfiguration(initialMovie: initialMovie, movieData: DM.favoritesList)

        
        //cellConfiguration
        cell.releaseLabel.attributedTextDisplay(headline: "Release: ", info: handleStringOptional(string: initialMovie.release_date))
        cell.titleLabel.attributedTextDisplay(headline: "Title: ", info: handleStringOptional(string: initialMovie.title))
        cell.scoreLabel.attributedTextDisplay(headline: "Score: ", info: handleFloatOptional(float: initialMovie.vote_average))
        cell.genreLabel.attributedTextDisplay(headline: "Genre: ", info: handleStringOptional(string: initialMovie.genres))
        
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
            service.fetchSingleMovie(url: url, discoverVC: self)
        }
    }

    @objc func actionTextFieldIsEditingChanged(sender: UITextField) {
        if sender.text?.isEmpty == true {
            movie = []
            discoverTableView.reloadData()
            alertView.isHidden = false
            alertLabel.text = "Browse movies online."
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
        
        let storyboard = UIStoryboard(name: "Discover", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailViewController
        
        nextViewController.movieData = movie[atRow]
        nextViewController.buildType = .buildForDetail
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    func userDidRequestSimilar(atRow: Int) {
        
        let storyboard = UIStoryboard(name: "Discover", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailViewController
        service.fetchSimilars(discoverVC: self, atRow: atRow, showVC: nextViewController) {
            DispatchQueue.main.async {
                nextViewController.similarMovies = self.similarMovies
                nextViewController.buildType = .buildForSimilar
                self.navigationController?.pushViewController(nextViewController, animated: true)

            }
        }
    }
    
}
