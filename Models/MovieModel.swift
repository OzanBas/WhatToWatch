//
//  PopularModel.swift
//  WhatToWatch?
//
//  Created by Ozan Bas on 12.01.2022.
//

import Foundation



struct MovieModel: Codable {
    let results: [Movies]
}

struct Movies: Codable, Equatable {
    let adult: Bool?
    let genre_ids : [Int]?
    let backdrop_path: String?
    let id: Int?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let vote_average: Float?
    let vote_count: Int?
    var genres : String? {convertGenre()}

    
    func convertGenre() -> String {
        var genresArray : [String] = []
        if let genre_ids = genre_ids {
            for i in genre_ids {
                switch i {
                case 28 :
                    genresArray.append("Action")
                case 12 :
                    genresArray.append("Adventure")
                case 16 :
                    genresArray.append("Animation")
                case 35 :
                    genresArray.append("Comedy")
                case 80 :
                    genresArray.append("Crime")
                case 99 :
                    genresArray.append("Documentary")
                case 18 :
                    genresArray.append("Drama")
                case 10751 :
                    genresArray.append("Family")
                case 14 :
                    genresArray.append("Fantasy")
                case 36 :
                    genresArray.append("History")
                case 27 :
                    genresArray.append("Horror")
                case 10402 :
                    genresArray.append("Music")
                case 9648 :
                    genresArray.append("Mystery")
                case 10749 :
                    genresArray.append("Romance")
                case 878 :
                    genresArray.append("Science Fiction")
                case 10770 :
                    genresArray.append("TV Movie")
                case 53 :
                    genresArray.append("Thriller")
                case 10752 :
                    genresArray.append("War")
                case 37 :
                    genresArray.append("Western")
                default :
                    continue
                }
            }
        }
        let stringGenres = genresArray.joined(separator: ", ")
        return stringGenres
    }
    
    
}
    
    
    
    
    
    
    
    
    
    
    
//    func convertGenre() -> [Int]?{
//        for i in genre_ids {
//            let genresArray : [Int] = []
//            var i : String {
//                switch genre_ids {
//                case 28 :
//                    return "Action"
//                case 12 :
//                    return "Adventure"
//                case 16 :
//                    return "Animation"
//                case 35 :
//                    return "Comedy"
//                case 80 :
//                    return "Crime"
//                case 99 :
//                    return "Documentary"
//                case 18 :
//                    return "Drama"
//                case 10751 :
//                    return "Family"
//                case 14 :
//                    return "Fantasy"
//                case 36 :
//                    return "History"
//                case 27 :
//                    return "Horror"
//                case 10402 :
//                    return "Music"
//                case 9648 :
//                    return "Mystery"
//                case 10749 :
//                    return "Romance"
//                case 878 :
//                    return "Science Fiction"
//                case 10770 :
//                    return "TV Movie"
//                case 53 :
//                    return "Thriller"
//                case 10752 :
//                    return "War"
//                case 37 :
//                    return "Western"
//                default :
//                    return "NoData"
//                }
//            }
//
//        }
//}
//}
//


//28    "Action"
//12   "Adventure"
//16   "Animation"
//35   "Comedy"
//80   "Crime"
//99   "Documentary"
//18  "Drama"
//10751  "Family"
//14   "Fantasy"
//36   "History"
//27   "Horror"
//10402  "Music"
//9648   "Mystery"
//10749  "Romance"
//878   "Science Fiction"
//10770  "TV Movie"
//53   "Thriller"
//10752   "War"
//37   "Western"
