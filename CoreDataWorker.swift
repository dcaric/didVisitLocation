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
    
    public struct User {
        var date : String
        var latitude : String
        var longitude : String
        var counter : Int16
    }
    
    public struct LocationModeRec {
        var mode : Int16
        var lastId : Int16
    }
    
    public func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    private func saveMode(modeKey: String, modeVal : Int16) -> Void {
        
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "LocationMode", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        //set the NEW value
        transc.setValue(modeVal, forKey: modeKey)
        //save the object
        do {
            try context.save()
            print("saved! New Value = \(modeVal)")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            print ("catch 2")
        }
    }
    
    
    private func deleteMode() -> Void {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"Device")
        
        do {
            let fetchModeResult = try getContext().fetch(fetchRequest)
            let fetchMode1 = fetchModeResult[0] as! NSManagedObject
            getContext().delete(fetchMode1)
            
        } catch  {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    public func storeTranscription (date: String, latitude: String, longitude: String, server: Bool, counter: Int16) {
        print("storeTranscription!")
        
        
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Device", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(date, forKey: "date")
        transc.setValue(latitude, forKey: "latitude")
        transc.setValue(longitude, forKey: "longitude")
        transc.setValue(counter, forKey: "counter")
        
        //save the object
        do {
            try context.save()
            print("storeTranscription: saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    
    
    
    
    
    public func getTranscriptions () -> Array<User> {
        
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
                print("\(trans.value(forKey: "counter"))")
                
                let User1 = User.init(date: (trans.value(forKey: "date") as! String), latitude: (trans.value(forKey: "latitude") as! String), longitude: (trans.value(forKey: "longitude") as! String), counter: (trans.value(forKey: "counter") as! Int16))
                
                users.append(User1)
                //print ("users = \(users[0].date)")
            }
        } catch {
            print("Error with request: \(error)")
        }
        
        
        
        return (users)
        
    }
    
    
    public func getLocationMode(keyVal : String) -> Int16 {
        
        var OldMode : Int16 = 0
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"LocationMode")
        
        // prepare to save in core data
        //let context = getContext()
        //let entity =  NSEntityDescription.entity(forEntityName: "LocationMode", in: context)
        //let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        var dataSize : Int = 0;
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            //print ("1: LocationMode size = \(searchResults.count)")
            dataSize = searchResults.count
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        // read the old value
        if (dataSize == 0) {
            print ("There are no element")
        }
        else {
            // fetch old mode
            do {
                let fetchModeResult = try getContext().fetch(fetchRequest)
                let fetchMode1 = fetchModeResult[0] as! NSManagedObject
                OldMode = fetchMode1.value(forKey: keyVal) as! Int16
                print("Mode Value = \(OldMode) for key = \(keyVal)")
                
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }
            
        }
        
        return OldMode
        
    }
    
    
    public func changeLocationMode(modeKey : String, modeVal : Int16) -> Void {
        
        var OldMode : Int16 = 0;
        
        var locationModeRec : Array<LocationModeRec> = []
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"LocationMode")
        
        // prepare to save in core data
        //let context = getContext()
        //let entity =  NSEntityDescription.entity(forEntityName: "LocationMode", in: context)
        //let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            print ("1: LocationMode size = \(searchResults.count)")
            
            
            // read the old value
            if (searchResults.count == 0) {
                print ("There are no element")
                //set the entity values
                let context = getContext()
                let entity =  NSEntityDescription.entity(forEntityName: "LocationMode", in: context)
                let transcTemp = NSManagedObject(entity: entity!, insertInto: context)
                if (modeKey == "mode") {
                    transcTemp.setValue(modeVal , forKey: "mode")
                    transcTemp.setValue(0, forKey: "lastId")
                }
                if (modeKey == "lastId") {
                    transcTemp.setValue(modeVal , forKey: "lastId")
                    transcTemp.setValue(0, forKey: "mode")
                }
                //transcTemp.setValue(locationModeRec[0].date, forKey: "date")
                //save the object
                do {
                    try context.save()
                    print("1 changeLocationMode: saved!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
                    
                }
                //self.saveMode(modeKey: modeKey, modeVal: modeVal)
            }
            else {
                // fetch old mode
                /*
                 do {
                 let fetchModeResult = try getContext().fetch(fetchRequest)
                 let fetchMode1 = fetchModeResult[0] as! NSManagedObject
                 OldMode = fetchMode1.value(forKey: modeKey) as! Int16
                 print("Old Value = \(OldMode) for key = \(modeKey)")
                 
                 } catch {
                 let fetchError = error as NSError
                 print(fetchError)
                 }
                 */
                
                var searchResults = try getContext().fetch(fetchRequest)
                print ("num of results = \(searchResults.count)")
                
                //You need to convert to NSManagedObject to use 'for' loops
                for trans in searchResults as! [NSManagedObject] {
                    print ("Inside searchResults")
                    //get the Key Value pairs (although there may be a better way to do that...
                    print("mode = \(trans.value(forKey: "mode"))")
                    print("lastId = \(trans.value(forKey: "lastId"))")
                    
                    let LocationModeRec1 = LocationModeRec.init(mode: (trans.value(forKey: "mode") as! Int16), lastId: (trans.value(forKey: "lastId") as! Int16))
                    
                    locationModeRec.append(LocationModeRec1)
                }
                
                // delete old record
                
                do {
                    let fetchModeResult = try getContext().fetch(fetchRequest)
                    let fetchMode1 = fetchModeResult[0] as! NSManagedObject
                    getContext().delete(fetchMode1)
                    
                } catch  {
                    let fetchError = error as NSError
                    print(fetchError)
                }
                //self.deleteMode()
                
                //set the entity values
                let context = getContext()
                let entity =  NSEntityDescription.entity(forEntityName: "LocationMode", in: context)
                let transcTemp = NSManagedObject(entity: entity!, insertInto: context)
                if (modeKey == "mode") {
                    transcTemp.setValue(modeVal , forKey: "mode")
                    transcTemp.setValue(locationModeRec[0].lastId, forKey: "lastId")
                }
                if (modeKey == "lastId") {
                    transcTemp.setValue(modeVal , forKey: "lastId")
                    transcTemp.setValue(locationModeRec[0].mode, forKey: "mode")
                }
                //save the object
                do {
                    try context.save()
                    print("2 changeLocationMode: saved!")
                    print ("mode =\(locationModeRec[0].mode)")
                    print ("lastId =\(locationModeRec[0].lastId)")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                } catch {
                    
                }
                
                //self.saveMode(modeKey: modeKey, modeVal: modeVal)
                
                //go check the results
                searchResults = try getContext().fetch(fetchRequest)
                print ("2: LocationMode size = \(searchResults.count)")
                
            }
            
        } catch {
            print ("catch 1")
            
        }
        
    }
    
    
    
    
    
    
    public func checkDate(dateToCheck : String) -> Bool {
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"Device")
        
        var result : Bool = false
        
        var dataSize : Int = 0;
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            //print ("data size = \(searchResults.count)")
            dataSize = searchResults.count
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        // check if there is already timestamp in database
        if (dataSize == 0) {
            print ("There are no element")
        }
        else {
            // fetch time
            do {
                
                fetchRequest.predicate = NSPredicate(format: "date CONTAINS %@", dateToCheck)
                let searchResults = try getContext().fetch(fetchRequest)
                var count : Int = 0
                for trans in searchResults as! [NSManagedObject] {
                    count += 1
                    print("date = \(trans.value(forKey: "date"))")
                }
                if (count > 0) {
                    result = true
                }
                
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }
            
        }
        
        return result
        
    }
    
}
