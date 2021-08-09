//
//  pray_timerApp.swift
//  pray timer
//
//  Created by admin on 2021/8/7.
//

import SwiftUI

@main
struct pray_timerApp: App {
    @StateObject var data = getTime()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(data)
        }
    }
}
