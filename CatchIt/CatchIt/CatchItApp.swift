//
//  CatchItApp.swift
//  CatchIt
//
//  Created by Hadi Zamani on 10/11/20.
//

import SwiftUI

@main
struct CatchItApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
