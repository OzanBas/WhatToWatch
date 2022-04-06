//
//  DetailViewController.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 8.03.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {

    
    //MARK: - PROPERTIES
    
    @IBOutlet weak var detailTableView: UITableView!
    var movieData : Movies?
    var DM = DataManagement()
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    
    //MARK: - HELPERS
    func configureTableView() {
        detailTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.rowHeight = view.frame.height * 0.8
        detailTableView.alwaysBounceVertical = false
        detailTableView.reloadData()
    }
    
    

}
    
    //MARK: - TABLEVIEW EXTENSION
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        cell.delegate = self
        
        if let posterPath = movieData?.poster_path {
            cell.detailCoverImageView.setCoverImage(posterPath: posterPath)
        }
        //MARK: - QUESTION: HOW TO HANDLE DYNAMIC CONSTRAINS IN INTERFACE BUILDER INSTEAD PROGRAMMATICALY??
        cell.detailCoverImageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.48).isActive = true
        cell.detailCoverImageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.35).isActive = true
        cell.detailCoverImageView.layer.cornerRadius = 5

        cell.releaseDateLabel.displayStringOptional(string: movieData?.release_date, headline: "Release: ")
        cell.voteCountLabel.displayIntOptional(int: movieData?.vote_count, headline: "Votes: ")
        cell.voteScoreLabel.displayFloatOptional(float: movieData?.vote_average, headline: "Score: ")
        cell.languageLabel.displayStringOptional(string: movieData?.original_language, headline: "Language: ")
        cell.overviewValue.text = movieData?.overview
        return cell
    }
}


extension MovieDetailViewController: DetailScreenButtonProtocol {
    func userDidRequestWatchList() {
        if let movie = movieData {
            DM.handleFavorites(movie: movie)
        }
        
    }
}
