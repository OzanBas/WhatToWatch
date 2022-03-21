//
//  UpcomingModel.swift
//  WhatToWatch?
//
//  Created by Ozan Bas on 12.01.2022.
//

import Foundation


struct UpcomingModel: Codable {
    let results: [UpcomingMovies]
}

struct UpcomingMovies: Codable {
    let adult: Bool
    let backdrop_path: String
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String
    let release_date: String
    let title: String
    let vote_average: Float
    let vote_count: Int
    
}

