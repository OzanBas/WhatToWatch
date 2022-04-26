//
//  MainController.swift
//  WhatToWatch?
//
//  Created by Ozan Bas on 9.02.2022.
//

import UIKit
import Kingfisher
import SwiftUI

class MainTabBarController: UIViewController , NavigationProtocol{

    
//MARK: - PROPERTIES

    let service = DataService()
    let apiParams = Endpoints()
    let titlesToBeFetched : [String] = ["Upcoming", "Popular", "TopRated"]
    
    @IBOutlet weak var mainMovieTableView: UITableView!
    
    var upcomingMovies: [Movies] = []
    var popularMovies: [Movies] = []
    var topRatedMovies: [Movies] = []

    
//MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainMovieTableView.delegate = self
        mainMovieTableView.dataSource = self
        
        setupTableView()

        service.fetchUpcoming(url: apiParams.urlupcoming(), tabBarVC: self)
        service.fetchPopular(url: apiParams.urlPopular(), tabBarVC: self)
        service.fetchTopRated(url: apiParams.urltopRated(), tabBarVC: self)
    }
    
//MARK: - HELPER FUNCS
    //configure ui
    func setupTableView() {
        mainMovieTableView.register(UINib(nibName: "MainMovieFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "MainMovieFeedTableViewCell")
        mainMovieTableView.translatesAutoresizingMaskIntoConstraints = false
        let heightBonus = view.frame.height / 10
        mainMovieTableView.rowHeight = 220 + heightBonus

    }
    
    
    //MARK: - NavigationProtocol Function
    func moveToDetailVC(movie: Movies) {
        
        let storyboard = UIStoryboard(name: "HomeFeed", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! MovieDetailViewController
        
        nextViewController.movieData = movie
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
}

//MARK: - TABLEVIEW EXTENSION
extension MainTabBarController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesToBeFetched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainMovieFeedTableViewCell", for: indexPath) as! MainMovieFeedTableViewCell
        
        cell.navigationDelegate = self
        cell.feedTitleLabel.text = titlesToBeFetched[indexPath.row]
        let cellTitle = cell.feedTitleLabel.text
        
        switch cellTitle {
        case "Popular":
            cell.model = popularMovies
        case "TopRated":
            cell.model = topRatedMovies
        default:
            cell.model = upcomingMovies
        }
        
        return cell
    }
}

