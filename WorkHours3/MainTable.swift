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


        var cell = tableView.dequeueReusableCell(withIdentifier: "SingleCell", for: indexPath) as! CellClass

        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "SingleCell") as! CellClass
        }

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.text = users[indexPath.row].date + "\n" + String(users[indexPath.row].counter)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }



    @IBAction func done (_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        print("done")
    }

}
