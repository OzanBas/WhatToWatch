//
//  Helpers.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 12.04.2022.
//

import Foundation


public func handleStringOptional(string: String?) -> String {

    if let string = string {
        let newString = String("\(string)")
        return newString
    } else {
        return "No Data."
    }
}

func handleIntOptional(int: Int?) -> String {

    if let int = int {
        let newString = String("\(int)")
        return newString
    } else {
        return "No Data."
    }
}

func handleFloatOptional(float: Float?) -> String {

    if let float = float {
        let newString = String("\(float)")
        return newString
    } else {
        return "No Data."
    }
}
