//
//  DetailTableViewCell.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 8.03.2022.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    //MARK: - Properties
    
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

//    func configureUI() {
//        let imageWidth = contentView.frame.width * 0.45
//        let imageHeight = contentView.frame.height * 0.3
//        detailCoverImageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
//        detailCoverImageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
//        
//        detailCoverImageView.layer.cornerRadius = 5
//    }
}
