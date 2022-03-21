//
//  DetailViewController.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 8.03.2022.
//

import UIKit


class MovieDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    
    @IBOutlet weak var detailTableView: UITableView!
    
    
    var movieData : Movies?
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    
    //MARK: - Helpers
    
    func configureTableView() {
        detailTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.rowHeight = view.frame.height * 0.8
        detailTableView.alwaysBounceVertical = false
        detailTableView.reloadData()
    }
    
    func detailLabelStringHandler(string: String?, headline: String) -> String {
        guard let string = string else {return "\(headline): No Data"}
        return String("\(headline): \(string)")
    }
    func detailLabelIntHandler(int: Int?, headline: String) -> String {
        guard let int = int else {return "\(headline): No Data"}
        return String("\(headline): \(int)")
    }
    
}
    

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        if let posterPath = movieData?.poster_path {
            cell.detailCoverImageView.setCoverImage(posterPath: posterPath)
        }
        
        cell.detailCoverImageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.48).isActive = true
        cell.detailCoverImageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.35).isActive = true
        cell.detailCoverImageView.layer.cornerRadius = 5

        cell.releaseDateLabel.text = detailLabelStringHandler(string: movieData?.release_date, headline: "Release")
        cell.voteCountLabel.text = detailLabelIntHandler(int: movieData?.vote_count, headline: "Votes")
        cell.voteScoreLabel.text = String("Score: \(movieData?.vote_average ?? 0)")
        cell.languageLabel.text = detailLabelStringHandler(string: movieData?.original_language, headline: "Language")
        cell.overviewValue.text = movieData?.overview
        return cell
    }
}
