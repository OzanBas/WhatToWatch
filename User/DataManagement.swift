//
//  DataManagement.swift
//  WhatToWatch
//
//  Created by Ozan Bas on 31.03.2022.
//

import Foundation




public class DataManagement {

    var favoritesList : [Movies] = []
    
    
    
    func handleFavorites(movie: Movies) {
        retrieveData()
        checkIfIncluded(movie: movie)
        storeData(movies: favoritesList)
    }
    
    
    func storeData(movies: [Movies]?) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(movies)
            UserDefaults.standard.set(data, forKey: "movies")
        } catch {
            print("UserDefaults Encode error:  \(error)")
        }
    }
    
    func retrieveData() {
        if let data = UserDefaults.standard.data(forKey: "movies") {
            do {
                let decoder = JSONDecoder()
                let retrievedData = try decoder.decode([Movies].self, from: data)
                self.favoritesList = retrievedData
            } catch {
                print("UserDefaults Unable to retrieve data: \(error)")
            }
        }
    }
    func checkIfIncluded(movie: Movies) {
        
        if let index = favoritesList.firstIndex(of: movie) {
            favoritesList.remove(at: index)
        } else {
            favoritesList.append(movie)
        }
    }
    
}
