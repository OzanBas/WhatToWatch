//
//  ApiParameters.swift
//  WhatToWatch?
//
//  Created by Ozan Bas on 14.01.2022.
//

import Foundation


class Endpoints {
    
    let apiKey = "d26e2033eed238ef5fdaf4d18a805b6e"

    
    let baseUrl = "https://api.themoviedb.org/3"
    let queryBase = "https://api.themoviedb.org/3/search/movie"
    let todoBase = "https://image.tmdb.org/t/p/original"
    let creditsBase = "https://api.themoviedb.org/3/movie/"

    
    
    let popular = "/movie/popular"
    let topRated = "/movie/top_rated"
    let upcoming = "/movie/upcoming"
    

//MARK: - URL Creators
    
    func urlPopular() -> URL? {
        let string = baseUrl + popular + "?api_key=" + apiKey
        let url =  URL(string: string)
        return url
    }
    
    func urltopRated() -> URL? {
        let string =  baseUrl + topRated + "?api_key=" + apiKey
        let url = URL(string: string)
        return url
    }
    
    func urlupcoming() -> URL? {
        let string = baseUrl + upcoming + "?api_key=" + apiKey
        let url = URL(string: string)
        return url
    }
    
    func movieSearch(query: String) -> URL? {
        let string = queryBase + "?api_key=" + apiKey + "&query=" + query
        let url = URL(string: string)
        return url
    }
    
    func urlSimilar(toMovie: String) -> URL? {
        let string = baseUrl + "/movie/\(toMovie)/similar" + "?api_key=" + apiKey
        let url =  URL(string: string)
        return url
    }
    
    func urlCredits(ofMovie: String) -> URL? {
        let string = creditsBase + ofMovie + "/credits?api_key=" + apiKey
        let url =  URL(string: string)
        return url
    }
    
}



