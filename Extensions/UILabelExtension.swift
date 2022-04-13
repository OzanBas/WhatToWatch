//
//  UILabelExtension.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 22.03.2022.
//

import UIKit

extension UILabel {
    

    
    func attributedTextDisplay(headline: String, info: String) {
        let headlineAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
        let infoAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let attributedHeadline = NSMutableAttributedString(string: headline, attributes: headlineAttributes)
        attributedHeadline.append(NSAttributedString(string: info, attributes: infoAttributes))
        
        self.attributedText = attributedHeadline
    }

    func handleStringOptional(string: String?) -> String {

        if let string = string {
            let newString = String("\(string)")
            return newString
        } else {
            return "No Data."
        }
    }
    
    
    
    
    func displayStringOptional(string: String?, headline: String) {

        if let string = string {
            let newString = String("\(string)")
            self.text = "\(headline) \(newString)"
        } else {
            self.text = "No Data."
        }
    }
    
    func displayIntOptional(int: Int?, headline: String) {
        
        if let int = int {
            let newString = String("\(headline) \(int)")
            self.text = newString
        } else {
            self.text = "No Data."
        }
    }
    
    func displayFloatOptional(float: Float?, headline: String) {
        if let float = float {
            let newString = String("\(headline) \(float)")
            self.text = newString
        } else {
            self.text = "No Data."
        }
    }
    
}


