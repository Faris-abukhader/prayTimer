//
//  countriesManager.swift
//  pray timer
//
//  Created by admin on 2021/8/8.
//

import Foundation

class CountriesManager {
    static let share = CountriesManager()
    
    func getCountriesList()->[dataPic]{
        var result = [dataPic]()
        guard let path = Bundle.main.url(forResource: "countries", withExtension: "json") else {return result}
        
        do {
            let data = try Data(contentsOf: path)
            let fetchedData = try JSONDecoder().decode([dataPic].self, from: data)
            result = fetchedData
        } catch {
            print(error)
        }
        return result
    }
    
    func getCountriesData() ->[countriesData] {
        var result = [countriesData]()
        guard let path = Bundle.main.url(forResource: "countries_with_timeZones", withExtension: "json") else {return result}
        
        do {
            let data = try Data(contentsOf: path)
            let fetchedData = try JSONDecoder().decode([countriesData].self, from: data)
            result = fetchedData
        } catch {
            print(error)
        }
        return result
    }
}

struct dataPic:Codable {
    var country:String = ""
    var city:String = ""
}


struct countriesData:Codable {
    var timezones: [String] = []
    var latlng: [Double] = []
    var name = ""
    var capital: String = ""

}

