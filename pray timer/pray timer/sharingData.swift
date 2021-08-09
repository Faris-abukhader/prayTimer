//  sharingData.swift
//  pray timer
//  Created by admin on 2021/8/8.

import Foundation

// sharing data class
class getTime :ObservableObject{
    @Published var PrayTimedata = [String]()
    @Published var prayTimeHour = 0
    @Published var prayTimeMinute = 0
    @Published var prayIndex = 0
    @Published var showLocationAlarm = false
    @Published var customCountryName = ""
    @Published var customCountry = false
    @Published var customCountryTime = ""
    @Published var customCountryTimeZone = ""
    @Published var latitude:Double = 0
    @Published var longitude:Double = 0
    @Published var showLocationBox = false
    
    
    
    func getDataCurrentPlace(comletion:@escaping (([String]) -> ())){
 
        if locationManager.shared.getUserLocationAutherization() {
            print("latitude \(self.latitude):\(self.longitude)")
            var urlString = ""
            if self.latitude != 0 && self.longitude != 0 {
                urlString = "http://api.aladhan.com/v1/timings/1398332113?latitude=\(self.latitude)&longitude=\(self.longitude)&method=3&school=1"
            }else{
                urlString = "http://api.aladhan.com/v1/timings/1398332113?latitude=\(locationManager.shared.getLocationCoordinate().latitude)&longitude=\(locationManager.shared.getLocationCoordinate().longitude)&method=3&school=1"
            }
            
            

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

                    self.PrayTimedata = result
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
    
    func getDataUsingCountryName(_ latitude:Double,_ longitude:Double){
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
                    self.PrayTimedata = result
                    
                }catch{
                    print(error.localizedDescription)
                }
              }
            }
        }.resume()
    }


    
}
