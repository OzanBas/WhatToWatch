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
    @IBOutlet weak var titleLabel: UILabel!
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DM.retrieveData()
        detailTableView.reloadData()
    }
    //MARK: - HELPERS
    func configureTableView() {
        detailTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.rowHeight = view.frame.height * 0.8
        detailTableView.alwaysBounceVertical = false
        detailTableView.reloadData()
        self.titleLabel.text = movieData?.title
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

        cell.detailCoverImageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.48).isActive = true
        cell.detailCoverImageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.35).isActive = true
        cell.detailCoverImageView.layer.cornerRadius = 5
        
        if let movieData = movieData {
            cell.watchlistButtonStateConfiguration(initialMovie: movieData, movieData: DM.favoritesList)
        }
        cell.releaseDateLabel.attributedTextDisplay(headline: "Release: ", info: handleStringOptional(string: movieData?.release_date))
        cell.voteCountLabel.attributedTextDisplay(headline: "Votes: ", info: handleIntOptional(int: movieData?.vote_count))
        cell.voteScoreLabel.attributedTextDisplay(headline: "Score: ", info: handleFloatOptional(float: movieData?.vote_average))
        cell.languageLabel.attributedTextDisplay(headline: "Language: ", info: handleStringOptional(string: movieData?.original_language))
        cell.genreLabel.attributedTextDisplay(headline: "Genre: ", info: handleStringOptional(string: movieData?.genres))
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
