//
//  ImageViewExtension.swift
//  WhatToWatch?
//
//  Created by Ozan Bas on 5.03.2022.
//

import UIKit
import Kingfisher
extension UIImageView {
    
    func setCoverImage(posterPath: String) {
        let apiBase = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: apiBase + posterPath)
        
        self.kf.setImage(with: url)
        
    }
}
