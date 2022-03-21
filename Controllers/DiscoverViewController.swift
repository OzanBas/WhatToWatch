//
//  DiscoverViewController.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 21.03.2022.
//

import UIKit




class DiscoverViewController: UIViewController {
    
    
    //MARK: - Properties
    
    
    @IBOutlet weak var discoverTableView: UITableView!
    
    var movie : [Movies] = []
    @IBOutlet weak var searchTextField: UITextField!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        discoverTableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: "SearchViewCell")
        discoverTableView.dataSource = self
        discoverTableView.delegate = self
        discoverTableView.rowHeight = 200
        
    }
    
    //MARK: - Helpers
    
    
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
    
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell

        cell.releaseLabel.text = String("Release: \(movie[indexPath.row].release_date)")
        cell.titleLabel.text = String("Title: \(movie[indexPath.row].original_title)")
        if let voteScore = movie[indexPath.row].vote_average {
            cell.scoreLabel.text = String("Score: \(voteScore)")
        }
        if let posterPath = movie[indexPath.row].poster_path {
            cell.coverImage.setCoverImage(posterPath: posterPath)
        }
        
        return cell
    }
}

extension DiscoverViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return searchTextField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text =  searchTextField.text {
            let correctedText = text.replacingOccurrences(of: " ", with: "+")
            let url = Endpoints().movieSearch(query: correctedText)
            searchMovie(url: url)
        }
    }
}

