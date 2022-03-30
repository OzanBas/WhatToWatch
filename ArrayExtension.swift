//
//  ArrayExtension.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 30.03.2022.
//

import Foundation


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted } 
    }
}
