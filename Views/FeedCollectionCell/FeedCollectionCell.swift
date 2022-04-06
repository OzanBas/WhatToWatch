//
//  FeedCollectionCellCollectionViewCell.swift
//  nibPlayground
//
//  Created by Ozan Bas on 9.02.2022.
//

import UIKit

class FeedCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var feedCellLabel: UILabel!
    @IBOutlet weak var feedCellImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
        let height = self.frame.height
        let width = self.frame.width
        
        feedCellImage.heightAnchor.constraint(equalToConstant: height * 0.8).isActive = true
        feedCellImage.widthAnchor.constraint(equalToConstant: width * 0.8).isActive = true
    }
}
