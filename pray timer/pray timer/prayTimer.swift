//
//  prayTimer.swift
//  pray timer
//
//  Created by admin on 2021/8/7.
//

import Foundation
import MapKit
import Contacts
import CoreLocation


struct prayTimer:Decodable {
    var timing = timings()
}
struct timings:Decodable{
    var Sunrise:String = ""
    var Dhuhr:String = ""
    var Asr:String = ""
    var Sunset:String = ""
    var Maghrib:String = ""
    var Isha:String = ""
}


struct prayTime: Codable {
//    let id = UUID()
    var code: Int
    var status: String
    var data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    var timings: Timings
}

// MARK: - Timings
struct Timings: Codable  {
    var Fajr:String
    var Sunrise:String
    var Dhuhr:String
    var Asr:String
    var Sunset:String
    var Maghrib:String
    var Isha:String
    var Imsak:String
    var Midnight:String

}


class Api {
    
    static let share = Api()

    let data = getTime()
    
    func getData(comletion:@escaping (([String]) -> ())){
        let urlString = "http://api.aladhan.com/v1/timingsByCity?city=yiwu&country=china&method=3&school=1"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!){data,_,error in
            DispatchQueue.main.async {
                if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decoderData = try decoder.decode(prayTime.self, from: data)
                    var result = [String]()
                    
                    result.append("\(decoderData.data.timings.Fajr)")
                    result.append("\(decoderData.data.timings.Sunrise)")
                    result.append("\(decoderData.data.timings.Dhuhr)")
                    result.append(" \(decoderData.data.timings.Asr)")
                    result.append("\(decoderData.data.timings.Maghrib)")
                    result.append("\(decoderData.data.timings.Isha)")

                    comletion(result)
                }catch{
                    print(error.localizedDescription)
                }
                }
            }
            
            
        }.resume()
        
        
    }
    
    func getDataUsingCountryName(_ latitude:Double,_ longitude:Double)->[String]{
        let urlString = "http://api.aladhan.com/v1/timings/1398332113?latitude=\(latitude)&longitude=\(longitude)&method=3&school=1"
        let url = URL(string: urlString)
        
        var result = [String]()

        URLSession.shared.dataTask(with: url!){data,_,error in
            DispatchQueue.main.async {
                if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decoderData = try decoder.decode(prayTime.self, from: data)
                    
                    //fetching data form api
                    result.append("\(decoderData.data.timings.Fajr)")
                    result.append("\(decoderData.data.timings.Sunrise)")
                    result.append("\(decoderData.data.timings.Dhuhr)")
                    result.append("\(decoderData.data.timings.Asr)")
                    result.append("\(decoderData.data.timings.Maghrib)")
                    result.append("\(decoderData.data.timings.Isha)")

                    //sending data to our praytime to use it
                    self.data.PrayTimedata = result
                    
                }catch{
                    print(error.localizedDescription)
                }
              }
            }
        }.resume()
        return result
    }
    
    func getDataCurrentPlace(comletion:@escaping (([String]) -> ())){
 
        if locationManager.shared.getUserLocationAutherization() {
            
        let urlString = "http://api.aladhan.com/v1/timings/1398332113?latitude=\(locationManager.shared.getLocationCoordinate().latitude)&longitude=\(locationManager.shared.getLocationCoordinate().longitude)&method=3&school=1"
            

        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!){data,_,error in
            DispatchQueue.main.async {
                if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decoderData = try decoder.decode(prayTime.self, from: data)
                    var result = [String]()
                    
                    result.append("\(decoderData.data.timings.Fajr)")
                    result.append("\(decoderData.data.timings.Sunrise)")
                    result.append("\(decoderData.data.timings.Dhuhr)")
                    result.append("\(decoderData.data.timings.Asr)")
                    result.append("\(decoderData.data.timings.Maghrib)")
                    result.append("\(decoderData.data.timings.Isha)")

                    self.data.PrayTimedata = result
                    comletion(result)
                }catch{
                    print(error.localizedDescription)
                }
                }
            }
            
            
        }.resume()
        
        
        }else {
            print("no autherization for location")
        }
    }
}
