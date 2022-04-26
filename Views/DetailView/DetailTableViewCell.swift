//
//  DetailTableViewCell.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 8.03.2022.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    var delegate: DetailScreenButtonProtocol?
    
    @IBOutlet weak var detailBGView: UIView!
    @IBOutlet weak var detailCoverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteScoreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var overviewValue: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var watchlistButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var castModel : [Cast] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let size = watchlistButton.frame.height
        watchlistButton.layer.cornerRadius = size / 2
        
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func watchlistButtonStateConfiguration(initialMovie: Movies, movieData: [Movies]) {
        
        if movieData.contains(initialMovie) {
            self.watchlistButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            self.watchlistButton.setImage(UIImage(systemName: "star"), for: .normal)
            
        }
    }
    
    @IBAction func watchlistButtonTapped(_ sender: UIButton) {
        delegate?.userDidRequestWatchList()
        DispatchQueue.main.async {
            if self.watchlistButton.imageView?.image == UIImage(systemName: "star") {
                self.watchlistButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                self.watchlistButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FeedCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FeedCollectionCell")
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    func configureCollectionViewCell(cell: FeedCollectionCell) {
        cell.feedCellImage.layer.cornerRadius = 10
        cell.feedCellImage.contentMode = .scaleAspectFit
    }

    
}

//MARK: - TABLEVIEW EXTENSION
extension DetailTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionCell", for: indexPath) as! FeedCollectionCell
        configureCollectionViewCell(cell: cell)
        
        
        cell.feedCellLabel.text = castModel[indexPath.row].originalName
        cell.feedCellLabel.font = .systemFont(ofSize: 10)
        if let profilePath = castModel[indexPath.row].profilePath {
            cell.feedCellImage.setCoverImage(posterPath: profilePath)
        }

        

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.frame.height
        let width = self.frame.width
        return CGSize(width: width * 0.17 , height: height * 0.20)
    }
}
