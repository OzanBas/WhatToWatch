//
//  ButtonsViewController.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 25.03.2022.
//

import UIKit

class SearchDetailViewController: UIViewController {
    
    //MARK: - PROPERTIES
    var movieData : Movies?
    
    var similarMovies : [Movies] = []
    
    let DM = DataManagement()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var buildType : BuildType?
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchDetailVC \(similarMovies.count)")
        
        tableView.delegate = self
        tableView.dataSource = self
       
        if buildType == .buildForDetail {
            configureDetailTableView()
            setTitleForDetail()
        } else {
            configureSimilarTableView()
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DM.retrieveData()
        tableView.reloadData()
    }
    
    //MARK: - BUILDSTYLE
    
    enum BuildType {
        case buildForDetail, buildForSimilar
    }
    
    func returnRows(build: BuildType) -> Int {
        if build == .buildForDetail {
            return rowCountForDetails()
        } else {
            return rowCountForSimilar()
        }
    }
    
//MARK: - FOR DETAIL BUILD
    func setTitleForDetail() {
        titleLabel.text = movieData?.title
    }
    
    func configureDetailTableView() {
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        tableView.rowHeight = view.frame.height * 0.8
        tableView.alwaysBounceVertical = false
    }
    
    func rowCountForDetails() -> Int {
        return 1
    }
    
    func detailCellConfig(cell: DetailTableViewCell) {
        cell.detailCoverImageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.48).isActive = true
        cell.detailCoverImageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.35).isActive = true
        cell.detailCoverImageView.layer.cornerRadius = 5
        
        cell.releaseDateLabel.attributedTextDisplay(headline: "Release: ", info: handleStringOptional(string: movieData?.release_date))
        cell.voteCountLabel.attributedTextDisplay(headline: "Votes: ", info: handleIntOptional(int: movieData?.vote_count))
        cell.voteScoreLabel.attributedTextDisplay(headline: "Score: ", info: handleFloatOptional(float: movieData?.vote_average))
        cell.languageLabel.attributedTextDisplay(headline: "Language: ", info: handleStringOptional(string: movieData?.original_language))
        cell.genreLabel.attributedTextDisplay(headline: "Genre: ", info: handleStringOptional(string: movieData?.genres))
        cell.overviewValue.text = handleStringOptional(string: movieData?.overview)
        if let posterPath = movieData?.poster_path {
            cell.detailCoverImageView.setCoverImage(posterPath: posterPath)
        }
        if let movieData = movieData {
            cell.watchlistButtonStateConfiguration(initialMovie: movieData, movieData: DM.favoritesList)
        }
    }
    
    
//MARK: - FOR SIMILAR BUILD
    func configureSimilarTableView() {
        tableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: "SearchViewCell")
        tableView.rowHeight = 200
    }
    
    func similarCellConfig(cell: SearchViewCell, indexPath: IndexPath) {
        cell.similarMoviesButton.isHidden = true
        cell.detailsButton.isHidden = true
        let width = cell.watchListButton.frame.width
        cell.watchListButton.layer.cornerRadius = width / 2
        
        if let posterPath = similarMovies[indexPath.row].poster_path {
            cell.coverImage.setCoverImage(posterPath: posterPath)
        }
        
        let initialMovie = similarMovies[indexPath.row]
        
        cell.releaseLabel.attributedTextDisplay(headline: "Release: ", info: handleStringOptional(string: initialMovie.release_date))
        cell.titleLabel.attributedTextDisplay(headline: "Title: ", info: handleStringOptional(string: initialMovie.title))
        cell.scoreLabel.attributedTextDisplay(headline: "Score: ", info: handleFloatOptional(float: initialMovie.vote_average))
        cell.genreLabel.attributedTextDisplay(headline: "Genre: ", info: handleStringOptional(string: initialMovie.genres))
        
        cell.watchlistButtonStateConfiguration(initialMovie: initialMovie, movieData: DM.favoritesList)
    }

    func rowCountForSimilar() -> Int {
        return similarMovies.count
    }
    
}

//MARK: - TABLEVIEW EXTENSION
extension SearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if buildType == .buildForDetail { // cell building single detail screen
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell
            cell.delegate = self
            detailCellConfig(cell: cell)

            return cell
        } else { // cell building for similar api search
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell
            cell.delegate = self

            cell.watchListButton.row = indexPath.row
            similarCellConfig(cell: cell, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        returnRows(build: buildType!)
}

}

extension SearchDetailViewController: FeatureButtonsProtocol {
    func userDidRequestWatchList(atRow: Int) {
        if buildType == .buildForSimilar {
            let selectedMovie = similarMovies[atRow]
            DM.handleFavorites(movie: selectedMovie)
        } else {
            if let selectedMovie = movieData {
                DM.handleFavorites(movie: selectedMovie)
            }
        }
    }
    
    func userDidRequestDetails(atRow: Int) {
//        non-functional
    }
    
    func userDidRequestSimilar(atRow: Int) {
//        non-functional
    }
}

extension SearchDetailViewController: DetailScreenButtonProtocol {
    func userDidRequestWatchList() {
        if let movie = movieData {
            DM.handleFavorites(movie: movie)
        }
    }
    
    
}
