//
//  ContentView.swift
//  CoreDataExampleSwiftUI
//
//  Created by Edison Gudiño on 9/6/21.
//

import SwiftUI
import CoreData


struct ContentView: View {
   
   @Environment(\.managedObjectContext) private var viewContext
   
   //Query for movies
   @FetchRequest(sortDescriptors:[])
   private var movies: FetchedResults<Movie>
   
   //Form Variables
   @State var nameMovie: String = ""
   @State var genderMovie: String = ""
   
   var body: some View {
      NavigationView{
         VStack {
            HStack{
               TextField("Name", text: $nameMovie).textFieldStyle(RoundedBorderTextFieldStyle())
               TextField("Gender", text: $genderMovie).textFieldStyle(RoundedBorderTextFieldStyle())
               Button("+ Add"){
                  addMovie(name: nameMovie, gender: genderMovie)
               }
            }
            List{
               ForEach(movies){ movie in
                  HStack{
                     Text(movie.name ?? "").bold()
                     Text(movie.gender ?? "")
                     Text("Score: \(movie.score)" ?? "")
                  }
               }.onDelete(perform: { indexSet in
                  deleteMovie(offset: indexSet)
               })
            }
            Spacer()
            
         }
         .navigationTitle("Movie List Database")
         .padding()
      }
   }
   // Delete from DB
   func deleteMovie(offset: IndexSet){
      withAnimation{
         offset.map{ movies[$0] }.forEach(viewContext.delete)
         //viewContext.delete(movies[offset]) also we can use like this passing the object
      }
   }
   // Add to DB
   func addMovie(name: String, gender: String){
      withAnimation{
         let movieDB = Movie(context: viewContext)
         movieDB.name = name
         movieDB.gender = gender
         movieDB.score = Int16(Int.random(in: 0..<10))
         movieDB.url = "https://www.disneyplus.com/"
         do{
            //save changes in db
            try viewContext.save()
         }catch{
            let error = error as NSError
            fatalError("Unresolved Error \(error)")
         }
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}

//MARK: Persistence Controller

struct PersistenceController{
   static let shared = PersistenceController()
   
   let container: NSPersistentContainer
   
   init(){
      container = NSPersistentContainer(name: "Movies")
      container.loadPersistentStores { (storeDescription, error) in
         if let error = error as NSError? {
            fatalError("Unresolved error: \(error)")
            
         }
      }
      
   }
   
   
}
