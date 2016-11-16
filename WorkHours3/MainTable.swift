//
//  TableViewController.swift
//  Aldo
//
//  Created by Dario Caric on 19/07/14.
//  Copyright (c) 2014 Dario Caric. All rights reserved.
//

import Foundation
import UIKit


@available(iOS 10.0, *)
class MainTable: UIViewController, UITableViewDelegate {
    //@IBOutlet
    //var tableView: UITableView
    

    var users: Array<CoreDataWorker.User> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    func numberOfSectionsInTableView(_ tableView: UITableView?) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        //print ("numberOfRowsInSection")
        let myCoreDataObj = CoreDataWorker()
        users = myCoreDataObj.getTranscriptions()
        return (users.count)
    }
    
    
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) ->
        UITableViewCell! {
            
            //print ("cellForRowAtIndexPath")

            
            let CellIdentifier : String = "Cell"
            
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
            //cell.textLabel.text = "Hello World"
            //cell.textLabel?.text = "Hello"
            
            cell.textLabel?.text = users[indexPath.row].date
            /*
             var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
             
             cell.textLabel.text = "Hello World"
             */
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected cell #\(indexPath.row)!")
    }
    
    /*
     func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
     /*
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     
     
     var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
     */
     
     //static NSString *CellIdentifier = @"Cell";
     
     var CellIdentifier : String = "Cell"
     
     var cell : UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as UITableViewCell
     cell.textLabel.text = "Hello World"
     
     return cell
     }
     */
    
    
    
    
    @IBAction func done (_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        print("done")
    }

}
