//
//  UILabelExtension.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 22.03.2022.
//

import UIKit

extension UILabel {
    
    //functions that handles optionals. Cleaner way to update cells in tableviews.

        
    func displayStringOptional(string: String?, headline: String) {
        if let string = string {
            let newString = String("\(headline) \(string)")
            self.text = newString
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


