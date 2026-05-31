//
//  GratefulMomentsApp.swift
//  GratefulMoments
//
//  Created by Venkatesh Munaga on 31/05/26.
//

import SwiftUI
import SwiftData

@main
struct GratefulMomentsApp: App {
    let dataContiner = DataContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataContiner)
        }
        .modelContainer(dataContiner.modelContainer)
    }
}
