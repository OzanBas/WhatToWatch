//
//  MainController.swift
//  WhatToWatch?
//
//  Created by Ozan Bas on 9.02.2022.
//

import UIKit
import Kingfisher

class MainTabBarController: UIViewController , NavigationProtocol{

    
//MARK: - PROPERTIES

    let apiParams = Endpoints()
    let titlesToBeFetched : [String] = ["Upcoming", "Popular", "TopRated"]
    
    @IBOutlet weak var mainMovieTableView: UITableView!
    
    var upcomingMovies: [Movies] = [] {
        didSet{
            DispatchQueue.main.async {
                self.mainMovieTableView.reloadData()
            }
        }
    }
    var popularMovies: [Movies] = [] {
        didSet{
            DispatchQueue.main.async {
                self.mainMovieTableView.reloadData()
            }
        }
    }
    var topRatedMovies: [Movies] = [] {
        didSet{
            DispatchQueue.main.async {
                self.mainMovieTableView.reloadData()
            }
        }
    }

    
//MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        mainMovieTableView.rowHeight = view.frame.height / 2.4
        
        mainMovieTableView.delegate = self
        mainMovieTableView.dataSource = self
        
        setupTableView()
        
        fetchUpcoming(url: apiParams.urlupcoming())
        fetchPopular(url: apiParams.urlPopular())
        fetchTopRated(url: apiParams.urltopRated())
    }
    
//MARK: - HELPER FUNCS
    //configure ui
    func setupTableView() {

        mainMovieTableView.translatesAutoresizingMaskIntoConstraints = false
        mainMovieTableView.rowHeight = view.frame.height / 2.6 + 60
        mainMovieTableView.register(UINib(nibName: "MainMovieFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "MainMovieFeedTableViewCell")
    }
    

    
    //data fetch
    func fetchUpcoming(url:  URL?) {
        URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.upcomingMovies = model.results
                    self.mainMovieTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchPopular(url:  URL?) {
        URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.popularMovies = model.results
                    self.mainMovieTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchTopRated(url:  URL?) {
        URLSession.shared.request(url: url, expecting: MovieModel.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.topRatedMovies = model.results
                    self.mainMovieTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func moveToDetailVC(movie: Movies) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! MovieDetailViewController
        
        nextViewController.movieData = movie
        self.navigationController?.pushViewController(nextViewController, animated: true)
        nextViewController.title = movie.title
        
        
    }
}

//MARK: - TABLEVIEW EXTENSION
extension MainTabBarController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesToBeFetched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainMovieFeedTableViewCell", for: indexPath) as! MainMovieFeedTableViewCell
        
        cell.feedTitleLabel.font = .boldSystemFont(ofSize: view.frame.width / 13)
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
