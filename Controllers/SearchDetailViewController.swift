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
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var buildType : BuildType?
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchDetailVC \(similarMovies.count)")
        
        tableView.delegate = self
        tableView.dataSource = self
       
        if buildType == .buildForDetail {
            configureDetailTableView()
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
        if buildType == .buildForDetail {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell
            detailCellConfig(cell: cell)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell
            similarCellConfig(cell: cell, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        returnRows(build: buildType!)
}

}
