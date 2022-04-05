//
//  MainMovieFeedTableViewCell.swift
//  nibPlayground
//
//  Created by Ozan Bas on 8.02.2022.
//

import UIKit



class MainMovieFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let detailVC = MovieDetailViewController()
    var navigationDelegate: NavigationProtocol?
    
    
    var model: [Movies] = [] {
        didSet{
            collectionView.reloadData()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FeedCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FeedCollectionCell")
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func configureCollectionViewCell(cell: FeedCollectionCell) {
        cell.feedCellImage.layer.cornerRadius = 5
        
    }

    
}

extension MainMovieFeedTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionCell", for: indexPath) as! FeedCollectionCell
        configureCollectionViewCell(cell: cell)
        
        cell.feedCellLabel.text = model[indexPath.row].title
        
        if let posterPath = model[indexPath.row].poster_path {
            cell.feedCellImage.setCoverImage(posterPath: posterPath)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellView.frame.width / 2.4, height: cellView.frame.size.width * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationDelegate?.moveToDetailVC(movie: model[indexPath.row])
        
    }
}
