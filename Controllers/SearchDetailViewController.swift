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
        cell.overviewValue.displayStringOptional(string: movieData?.overview, headline: "")
        cell.languageLabel.displayStringOptional(string: movieData?.original_language, headline: "Language: ")
        cell.voteCountLabel.displayIntOptional(int: movieData?.vote_count, headline: "Votes: ")
        cell.releaseDateLabel.displayStringOptional(string: movieData?.release_date, headline: "Release: ")
        if let posterPath = movieData?.poster_path {
            cell.detailCoverImageView.setCoverImage(posterPath: posterPath)
        }
        cell.voteScoreLabel.displayFloatOptional(float: movieData?.vote_average, headline: "Score: ")
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
        
        cell.scoreLabel.displayFloatOptional(float: similarMovies[indexPath.row].vote_average, headline: "Score: ")
        if let posterPath = similarMovies[indexPath.row].poster_path {
            cell.coverImage.setCoverImage(posterPath: posterPath)
        }
        cell.titleLabel.displayStringOptional(string: similarMovies[indexPath.row].title, headline: "Title: ")
        cell.releaseLabel.displayStringOptional(string: similarMovies[indexPath.row].release_date, headline: "Release: ")
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
            cell.watchlistButton.setImage(UIImage(systemName: "star"), for: .normal)

            return cell
        } else { // cell building for similar api search
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell
            cell.delegate = self
            cell.watchListButton.setImage(UIImage(systemName: "star"), for: .normal)

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
