//
//  CoreDataWorker.swift
//  CheckOutIn
//
//  Created by Dario Caric on 30/10/2016.
//  Copyright © 2016 Dario Caric. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import os

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
            os_log("saved! New Value = %i",modeVal)
        } catch let error as NSError  {
            os_log("Could not save error=%s, error.userInfo=%s",error,error.userInfo)
        } catch {
            os_log("catch")
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
            os_log("Could not save error=%s",fetchError)
        }
    }
    
    
    // Store data in Device core data
    public func storeTranscription (date: String, latitude: String, longitude: String, server: Bool, counter: Int16) {
        //retrieve the entity
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Device", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(date, forKey: "date")
        transc.setValue(latitude, forKey: "latitude")
        transc.setValue(longitude, forKey: "longitude")
        transc.setValue(counter, forKey: "counter")
        
        //save the object
        do {
            try context.save()
            os_log("storeTranscription: saved!")
        } catch let error as NSError  {
            os_log("Could not save error=%s, error.userInfo=%s",error,error.userInfo)
        } catch {
            
        }
    }
    
    
    
    
    
    // Read data from Device core data into array
    public func getTranscriptions () -> Array<User> {
        
        var users: Array<User> = []

        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"Device")
        
        
        do {
            //get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //Size of the returned results
            os_log ("num of results = %d",searchResults.count)
            
            
            //You need to convert to NSManagedObject to use 'for' loops
            for trans in searchResults as! [NSManagedObject] {
                os_log("date = %s",trans.value(forKey: "date") as! CVarArg)
                os_log("latitude = %s",trans.value(forKey: "latitude") as! CVarArg)
                os_log("longitude = %s",trans.value(forKey: "longitude") as! CVarArg)
                os_log("counter = %i",trans.value(forKey: "counter") as! CVarArg)
                
                // Build User1 type of structure User - 1 entry
                let User1 = User.init(date: (trans.value(forKey: "date") as! String), latitude: (trans.value(forKey: "latitude") as! String), longitude: (trans.value(forKey: "longitude") as! String), counter: (trans.value(forKey: "counter") as! Int16))
                
                // Add User1 entry into users array
                users.append(User1)
            }
        } catch {
            let fetchError = error as NSError
            os_log("Error = %s", fetchError)
        }
        
        
        
        return (users)
        
    }
    
    
    
    // Read entities from table LocationMode
    public func getLocationMode(keyVal : String) -> Int16 {
        
        var OldValue : Int16 = 0
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"LocationMode")
        
        var dataSize : Int = 0;
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            dataSize = searchResults.count
        } catch {
            let fetchError = error as NSError
            os_log("Error = %s", fetchError)
        }
        
        // read the old value
        if (dataSize == 0) {
            os_log("There are no elements")
        }
        else {
            // fetch old mode
            do {
                let fetchModeResult = try getContext().fetch(fetchRequest)
                let fetchMode1 = fetchModeResult[0] as! NSManagedObject
                OldValue = fetchMode1.value(forKey: keyVal) as! Int16
                os_log("Value = %i for key =%s",OldValue,keyVal)
            } catch {
                let fetchError = error as NSError
                os_log("Error = %s", fetchError)
            }
            
        }
        
        return OldValue
        
    }
    
    
    // Updae entities from table LocationMode
    public func changeLocationMode(modeKey : String, modeVal : Int16) -> Void {
        
        
        var locationModeRec : Array<LocationModeRec> = []
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"LocationMode")
        
        // prepare to save in core data
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "LocationMode", in: context)
        //let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            os_log ("Size = %d",searchResults.count)
            
            
            // If size == 0 - first time update
            if (searchResults.count == 0) {
                os_log("There are no elements until now, size = 0")
                //set the entity values
                // Case for mode entity
                let transcTemp = NSManagedObject(entity: entity!, insertInto: context)
                if (modeKey == "mode") {
                    transcTemp.setValue(modeVal , forKey: "mode")
                    transcTemp.setValue(0, forKey: "lastId")
                    os_log("mode = %i lastId = 0",modeVal)
                }
                // Case for lastId entity
                if (modeKey == "lastId") {
                    transcTemp.setValue(modeVal , forKey: "lastId")
                    transcTemp.setValue(0, forKey: "mode")
                    os_log("lastId = %i mode = 0",modeVal)
                    
                }
                //transcTemp.setValue(locationModeRec[0].date, forKey: "date")
                
                //Now save the object
                do {
                    try context.save()
                    os_log("Object saved in LocationMode")
                } catch let error as NSError  {
                    os_log("Could not save error=%s, error.userInfo=%s",error,error.userInfo)
                    
                } catch {
                    
                }
            }
                
                // If size != 0 - update entities in the table
            else {
                // fetch old mode
                var searchResults = try getContext().fetch(fetchRequest)
                os_log("Size = %i",searchResults.count)
                
                //You need to convert to NSManagedObject to use 'for' loops
                for trans in searchResults as! [NSManagedObject] {
                    //get the Key Value pairs (although there may be a better way to do that...
                    os_log("mode = %i",trans.value(forKey: "mode") as! CVarArg)
                    os_log("lastId = %i",trans.value(forKey: "lastId") as! CVarArg)
                    
                    // Set one entity of LocationModeRec
                    let LocationModeRec1 = LocationModeRec.init(mode: (trans.value(forKey: "mode") as! Int16), lastId: (trans.value(forKey: "lastId") as! Int16))
                    
                    // Build array - it will be only 1 record but this is easier to handle
                    // Via array os struc LocationModeRec
                    locationModeRec.append(LocationModeRec1)
                }
                
                
                
                // We have now saved old values in locationModeRec
                // Delete now old record from core data
                do {
                    let fetchModeResult = try getContext().fetch(fetchRequest)
                    let fetchMode1 = fetchModeResult[0] as! NSManagedObject
                    getContext().delete(fetchMode1)
                    os_log("Record deleted in LocationMode")
                } catch  {
                    let fetchError = error as NSError
                    os_log("Could not save, error = %i",fetchError)
                }
                
                
                //Now set nand save new values in LocationMode
                let transcTemp = NSManagedObject(entity: entity!, insertInto: context)
                // Case for mode
                if (modeKey == "mode") {
                    transcTemp.setValue(modeVal , forKey: "mode")
                    transcTemp.setValue(locationModeRec[0].lastId, forKey: "lastId")
                    os_log("Setting mode = %i lastId = %i",modeVal,locationModeRec[0].lastId)
                }
                // Case for lastId
                if (modeKey == "lastId") {
                    transcTemp.setValue(modeVal , forKey: "lastId")
                    transcTemp.setValue(locationModeRec[0].mode, forKey: "mode")
                    os_log("Setting lastId = %i mode = %i",modeVal,locationModeRec[0].mode)
                    
                }
                //save the object
                do {
                    try context.save()
                    os_log("Saved mode = %i",locationModeRec[0].mode)
                    os_log("Saved lastId = %i",locationModeRec[0].lastId)
                    
                } catch let error as NSError  {
                    os_log("Could not save, error = %i",error)
                } catch {
                    
                }
                
                //go check the results
                searchResults = try getContext().fetch(fetchRequest)
                os_log("Size = %i",searchResults.count)
            }
            
        } catch {
            
        }
        
    }
    

}
