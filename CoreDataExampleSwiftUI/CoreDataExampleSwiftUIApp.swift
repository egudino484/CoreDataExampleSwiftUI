//
//  CoreDataExampleSwiftUIApp.swift
//  CoreDataExampleSwiftUI
//
//  Created by Edison Gudiño on 9/6/21.
//

import SwiftUI

@main
struct CoreDataExampleSwiftUIApp: App {
   let persistenceContainer = PersistenceController.shared
   var body: some Scene {
      WindowGroup {
         ContentView()
            .environment(\.managedObjectContext,
                         persistenceContainer.container.viewContext )//Add context to view
         
      }
   }
}
