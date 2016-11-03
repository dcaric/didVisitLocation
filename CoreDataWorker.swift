//
//  CoreDataWorker.swift
//  WorkHours3
//
//  Created by Dario Caric on 30/10/2016.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@available(iOS 10.0, *)
class CoreDataWorker: NSObject {
    
    struct User {
        var date : String
        var latitude : String
        var longitude : String
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    func storeTranscription (date: String, latitude: String, longitude: String) {
        print("storeTranscription!")

        
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Device", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(date, forKey: "date")
        transc.setValue(latitude, forKey: "latitude")
        transc.setValue(longitude, forKey: "longitude")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    
    
    
    
    
    func getTranscriptions () -> Array<User> {
        
        var users: Array<User> = []
        //var users: [User] = []

        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"Device")
        
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            
            //You need to convert to NSManagedObject to use 'for' loops
            for trans in searchResults as! [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                print("\(trans.value(forKey: "date"))")
                print("\(trans.value(forKey: "latitude"))")
                print("\(trans.value(forKey: "longitude"))")
                
                let User1 = User.init(date: (trans.value(forKey: "date") as! String), latitude: (trans.value(forKey: "latitude") as! String), longitude: (trans.value(forKey: "longitude") as! String))
                
                users.append(User1)
                //print ("users = \(users[0].date)")
            }
        } catch {
            print("Error with request: \(error)")
        }
        
        
        
         return (users)
    
    }
    
}
