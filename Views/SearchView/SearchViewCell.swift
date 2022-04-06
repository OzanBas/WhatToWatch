//
//  SearchView.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 21.03.2022.
//

import UIKit





class SearchViewCell: UITableViewCell {

    var delegate : FeatureButtonsProtocol?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var watchListButton: CustomUIButton!
    @IBOutlet weak var detailsButton: CustomUIButton!
    @IBOutlet weak var similarMoviesButton: CustomUIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImage.layer.cornerRadius = 10
        
        buttonConfiguration(button: watchListButton)
        buttonConfiguration(button: detailsButton)
        buttonConfiguration(button: similarMoviesButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buttonConfiguration(button: UIButton) {
        let size = watchListButton.frame.width
        button.layer.cornerRadius = size / 2
    }
    
    
    @IBAction func watchlistButtonTapped(_ sender: CustomUIButton) {
        delegate?.userDidRequestWatchList(atRow: sender.row!)
    }
    @IBAction func detailButtonTapped(_ sender: CustomUIButton) {
        delegate?.userDidRequestDetails(atRow: sender.row!)
    }
    @IBAction func similarMoviesTapped(_ sender: CustomUIButton) {
        delegate?.userDidRequestSimilar(atRow: sender.row!)
    }
    
}
