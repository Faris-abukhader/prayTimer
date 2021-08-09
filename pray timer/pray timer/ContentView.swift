//  ContentView.swift
//  pray timer
//  Created by admin on 2021/8/7.

import SwiftUI
import AVFoundation


struct ContentView: View {
    
    @EnvironmentObject var userdata:getTime
    
    // fire countdown
    let time = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var oneMinute = 60
    @State var hourToPray = 0
    @State var minuteToPray = 0
    @State var secondToPray = 60
    
    // current time ( hour , minute )
    @State var currentHour = Calendar.current.component(.hour, from: Date())
    @State var currentMinute = Calendar.current.component(.minute, from: Date())
    
    
    var prayName = ["Fajr","Sunrise","Dhuhr","Asr","Maghrib","Isha"]
    
    
    var body: some View {
        ZStack{
            
            ZStack(alignment:.top){
                
            HStack{
                // this button to show up location (countries and cities) box
                Button(action: {
                    withAnimation{
                        userdata.showLocationBox.toggle()
                    }
                }, label: {
                    ZStack{
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("lightPink"))
                            .opacity(0.3)
                            .shadow(radius: 3)
                            .padding(.leading,40)
                        
                        Image(systemName: "globe")
                            .resizable()
                            .foregroundColor(Color("darkBlue"))
                            .frame(width: 40, height: 40)
                            .padding(.leading,40)
                        
                    }.padding(.top)
                    

                })
                
                
                
                Spacer()
                


            }.frame(width: UIScreen.main.bounds.width, height: 20)
            .offset(y:60)
            
            
            
            VStack{
                if userdata.PrayTimedata.count > 0 {
                ZStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width/2, height: 99)
                        .foregroundColor(Color("lightBlue"))
                        .opacity(0.1)
                        .cornerRadius(30)
                        .shadow(radius: 1)
                        
                VStack{
                
                    Text("\(userdata.prayTimeHour < 10 ? "0":"" )\(userdata.prayTimeHour):\(userdata.prayTimeMinute < 10 ? "0":"")\(userdata.prayTimeMinute):\(secondToPray < 10 ? "0":"")\(secondToPray)").font(.title).foregroundColor(.black).onReceive(time, perform: { _ in
                        
                        
                        if secondToPray >= 1 {
                            secondToPray-=1
                        }else  {
                            if userdata.prayTimeMinute > 0 {
                                secondToPray = 60
                                userdata.prayTimeMinute-=1
                                if userdata.prayTimeMinute == 0 && userdata.prayTimeHour > 0 {
                                    userdata.prayTimeMinute+=60
                                    userdata.prayTimeHour-=1
                                }
                            }else {
                                if userdata.prayTimeHour > 0 {
                                    userdata.prayTimeHour-=1
                                    userdata.prayTimeMinute+=60
                                    secondToPray = 60
                                }else{
                                    userdata.prayTimeMinute = 0
                                    userdata.prayTimeHour = 0
                                    secondToPray = 0
                                    time.upstream.connect().cancel()
                                    
                                }
                            }
                        }
                })
                    
    
                    HStack{
                        Text(LocalizedStringKey("remainedTo"))
                            .foregroundColor(.black)
                        Text(LocalizedStringKey(prayName[userdata.prayIndex]))
                            .foregroundColor(.black)

                    }
                    if userdata.customCountry {
                        Text(userdata.customCountryName).font(.footnote).foregroundColor(.black)
                    }
                    
                        
                        
                        
                    
                   }
                 }.frame(height: 100)
                .padding(.vertical)
                .padding(.bottom)
                .padding(.top,60)
                    
                    // showing up our main data . . .
                    ForEach(0..<userdata.PrayTimedata.count,id:\.self){index in
                        ZStack{
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width - 50, height: 80)
                                .foregroundColor(Color("lightBlue"))
                                .opacity(0.2)
                                .cornerRadius(20)
                            
                            HStack{
                                
                                Text(LocalizedStringKey(prayName[index])).padding(.leading).font(.title2)
                                    .padding().foregroundColor(.black)
                            
                            Spacer()
                                
                            Text("\(getHourAndMinFromStr12(userdata.PrayTimedata[index]).hour < 10 ? "0\(getHourAndMinFromStr12(userdata.PrayTimedata[index]).hour)":"\(getHourAndMinFromStr12(userdata.PrayTimedata[index]).hour)" ):\(getHourAndMinFromStr12(userdata.PrayTimedata[index]).min < 10 ? "0\(getHourAndMinFromStr12(userdata.PrayTimedata[index]).min)":"\(getHourAndMinFromStr12(userdata.PrayTimedata[index]).min)")").font(.title2)
                                .padding().foregroundColor(.black)
                                .padding(.trailing)

                            }
                            .frame(width: UIScreen.main.bounds.width - 50)

                            
                         }
                       }

                    
                }
                
            }.frame( height: UIScreen.main.bounds.height)
                
                
               
                Button(action: {
                        userdata.customCountry=false
                        userdata.latitude = 0
                        userdata.longitude = 0
                        userdata.getDataCurrentPlace { (_: [String]) in}
                }, label: {
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color("darkBlue"))
                            .frame(width: 60, height: 60)
                            .cornerRadius(50)
                            .opacity(0.2)
                      VStack{
                        Image(systemName: "arrowshape.turn.up.backward.2.circle").foregroundColor(.black)
                        Text("default").font(.footnote).foregroundColor(.black)
                     }
                    }
                    
                    
                }).offset(x:UIScreen.main.bounds.width/2-40, y: userdata.customCountry ? UIScreen.main.bounds.height/6:-UIScreen.main.bounds.height )
                
                

           }
            .alert(isPresented: $userdata.showLocationAlarm, content: {
            Alert(title: Text("Warning"), message: Text("this app need lcation until it work , to give the permission go to settings -> pray timer - > location"), dismissButton: Alert.Button.default(Text("Ok"), action: {}))
        })

            .blur(radius: userdata.showLocationBox ? 4:0)
            .onTapGesture {
                userdata.showLocationBox = false
                for i in userdata.PrayTimedata {
                    print("data is \(i)")
                }
            }
            
            
            
            
            
            // location picker box ....
            ChoosingCountryView()
            .offset(y: userdata.showLocationBox ? UIScreen.main.bounds.height/4 :UIScreen.main.bounds.height * 2).environmentObject(userdata)

        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(LinearGradient(gradient: Gradient(colors: [Color("darkBlue"),Color("lightPink")]), startPoint: .top, endPoint: .bottom))
        
        .onAppear{
            
            // to get the premission for location
            locationManager.shared.getUserLocationAutherization()
            
            // to get authorization for pushing notifications (getting bool from this functions) when the app is opened
            let isAutherizedToPushNotifications = notificationCenter.intance.requestAutherization()
            
            // when the app opened the little red notification on the application icon will disappear
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            
            
            if locationManager.shared.getUserLocationAutherization() {
                userdata.getDataCurrentPlace{ (prayTime) in}
            }
            

        }
        .onReceive(time, perform: { _ in
            
            
            // waiting two second before show up countdown to be share that the data from api was fetched successfully
            if( userdata.PrayTimedata.count > 0){
                oneMinute-=1
                
                // if we get the autherization we push the notification from here
                notificationCenter.intance.scheduleNotifications()
                nextTimerForNextPray()
                


            }
            if oneMinute == 59 {
            }
            
            
        })
    }
    
    func isNext(_ possibleNextPrayHour:Int,_ possibleNextPrayMinute:Int,_ currentHour:Int,_ currentMinute:Int)->Bool{
        let possible = possibleNextPrayHour*60 + possibleNextPrayMinute
        let current = currentHour*60 + currentMinute
        return possible >= current
    }

       
    func nextTimerForNextPray(){
        let CurrentHour = userdata.customCountry ? getHourAndMinFromStr(getDateAndTime(timeZoneIdentifier: userdata.customCountryTimeZone)!).hour : currentHour
        let CurrentMinute = userdata.customCountry ? getHourAndMinFromStr(getDateAndTime(timeZoneIdentifier: userdata.customCountryTimeZone)!).min : currentMinute
        var hour = 0, minute = 0
        for index in 0..<userdata.PrayTimedata.count {
            let possibleNextPrayHour = getHourAndMinFromStr(userdata.PrayTimedata[index]).hour
            let possibleNextPrayMinute = getHourAndMinFromStr(userdata.PrayTimedata[index]).min
            
            print("current hour \(CurrentHour)")
            print("current minute \(CurrentMinute)")
            print("possible hour \(possibleNextPrayHour)")
            print("possible minute \(possibleNextPrayHour)")
            
            if isNext(possibleNextPrayHour,possibleNextPrayMinute,CurrentHour,CurrentMinute) {
                userdata.prayIndex = index
                
                
                
                hour = possibleNextPrayHour - CurrentHour
                minute = possibleNextPrayMinute - CurrentHour

                
                print("\(hour):\(minute)")

                
                if hour < 0 {
                    hour = hour * -1
                }
                if minute < 0 && hour > 0 {
                    hour-=1
                    minute+=60
                }else if minute < 0  {
                    minute = minute * -1
                }
                userdata.prayTimeHour = hour
                userdata.prayTimeMinute = minute
                return
            }
            if index == userdata.PrayTimedata.count-1 && userdata.prayIndex == 0 {
                let possibleNextPrayHour = getHourAndMinFromStr(userdata.PrayTimedata[0]).hour
                let possibleNextPrayMinute = getHourAndMinFromStr(userdata.PrayTimedata[0]).min
        
                
                
                if currentHour > 12 {
                    hour = 24 - CurrentHour + possibleNextPrayHour
                }else {
                    hour = possibleNextPrayHour - CurrentHour
                }
                
                
                
                if hour < 0 {
                    hour = hour * -1
                }
                if minute < 0 {
                    minute = minute * -1
                }
                userdata.prayTimeHour = hour 
                userdata.prayTimeMinute = minute
                return

            }
        }
    }
    
    
    func getDateAndTime(timeZoneIdentifier: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        dateFormatter.timeStyle = .short
        print(dateFormatter.string(from: Date()))
        return dateFormatter.string(from: Date())
    }
        
}


func getHourAndMinFromStr(_ str:String) ->(hour:Int,min:Int){
    let array = str.map({String($0)})
    var hour = "" , min = ""
    for index in 0..<str.count{
        if array[index] == ":" {
            for i in 0..<index {
                hour += array[i]
            }
            for i in index+1..<index+3 {
                min += array[i]
            }
        }
    }
    return(Int(hour) ?? 0,Int(min) ?? 0)
}

func getHourAndMinFromStr12(_ str:String) ->(hour:Int,min:Int){
    let array = str.map({String($0)})
    var hour = "" , min = ""
    for index in 0..<str.count{
        if array[index] == ":" {
            for i in 0..<index {
                hour += array[i]
            }
            for i in index+1..<str.count {
                min += array[i]
            }
        }
    }
    if Int(hour)! > 12 {
        hour = String(Int(hour)! - 12)
    }
    return(Int(hour) ?? 0,Int(min) ?? 0)
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




struct ChoosingCountryView:View{
    @EnvironmentObject var data:getTime
    var body: some View{
        ZStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                .cornerRadius(40)
                .shadow(radius: 5)
                .opacity(0.5)
                .foregroundColor(Color("darkBlue"))
            
        VStack{
            ScrollView(showsIndicators: false) {
            ForEach(0..<CountriesManager.share.getCountriesData().count,id:\.self){ index in
                Button(action: {
                    data.PrayTimedata =  Api.share.getDataUsingCountryName(CountriesManager.share.getCountriesData()[index].latlng[0],CountriesManager.share.getCountriesData()[index].latlng[1])
                    data.customCountry = true
                }, label: {
                    Text(CountriesManager.share.getCountriesData()[index].name)
                        .bold()
                        .padding()
                        .foregroundColor(.black)
                })
                .frame(width: UIScreen.main.bounds.width)

            
           }
          }.padding(.top)
         }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
    }
}
extension Calendar {

    // case 1
    func dateBySetting(timeZone: TimeZone, of date: Date) -> Date? {
        var components = dateComponents(in: self.timeZone, from: date)
        components.timeZone = timeZone
        return self.date(from: components)
    }

    // case 2
    func dateBySettingTimeFrom(timeZone: TimeZone, of date: Date) -> Date? {
        var components = dateComponents(in: timeZone, from: date)
        components.timeZone = self.timeZone
        return self.date(from: components)
    }
}

struct choosingCountryView:View{
    @EnvironmentObject var userdata:getTime
    var body: some View{
        ZStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                .cornerRadius(40)
                .shadow(radius: 5)
                .opacity(0.5)
                .foregroundColor(Color("darkBlue"))
            
        VStack{
            ScrollView(showsIndicators: false) {
            ForEach(0..<CountriesManager.share.getCountriesData().count,id:\.self){ index in
                Button(action: {
                    
                    userdata.latitude = CountriesManager.share.getCountriesData()[index].latlng[0]
                    userdata.longitude = CountriesManager.share.getCountriesData()[index].latlng[1]
                    userdata.customCountryTimeZone = CountriesManager.share.getCountriesData()[index].timezones[0]
                    userdata.getDataCurrentPlace{ (prayTime) in}

                    userdata.customCountry = true
                    userdata.customCountryName = CountriesManager.share.getCountriesData()[index].name

                    userdata.showLocationBox = false
                }, label: {
                    Text(CountriesManager.share.getCountriesData()[index].name)
                        .bold()
                        .padding()
                        .foregroundColor(.black)
                })
                .frame(width: UIScreen.main.bounds.width)

            
           }
          }.padding(.top)
         }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)

    }
}
