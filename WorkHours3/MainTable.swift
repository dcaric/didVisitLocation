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
class MainTable: UITableViewController {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print ("numberOfRowsInSection")
        let myCoreDataObj = CoreDataWorker()
        users = myCoreDataObj.getTranscriptions()
        return (users.count)
    }






    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //print ("cellForRowAtIndexPath")

        var cell = tableView.dequeueReusableCell(withIdentifier: "SingleCell", for: indexPath) as! CellClass


        //var cell = tableView.dequeueReusableCell(withIdentifier: "SingleCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "SingleCell") as! CellClass
        }

        //cell.textLabel.text = "Hello World"
        //cell.textLabel?.text = "Hello"

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.text = users[indexPath.row].date + "\n" + String(users[indexPath.row].counter)
        //cell?.detailTextLabel?.text = String(users[indexPath.row].counter)
        //cell?.textLabel?.text = String(users[indexPath.row].counter)
        /*
         var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell

         cell.textLabel.text = "Hello World"
         */

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
