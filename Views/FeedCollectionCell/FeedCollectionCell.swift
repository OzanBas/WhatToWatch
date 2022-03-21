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
        feedCellLabel.text = "Preview"
    }
}
