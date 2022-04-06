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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let size = watchlistButton.frame.height
        watchlistButton.layer.cornerRadius = size / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func watchlistButtonTapped(_ sender: UIButton) {
        delegate?.userDidRequestWatchList()
    }
    
}
