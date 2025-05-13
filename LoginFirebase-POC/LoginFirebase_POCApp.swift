//
//  LoginFirebase_POCApp.swift
//  LoginFirebase-POC
//
//  Created by Jorge de Carvalho on 12/05/25.
//

import SwiftUI

@main
struct LoginFirebase_POCApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            CreateUser()
        }
    }
}
