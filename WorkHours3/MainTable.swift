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

    var users: Array<CoreDataWorker.User> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView?) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        let myCoreDataObj = CoreDataWorker()
        users = myCoreDataObj.getTranscriptions()
        return (users.count)
    }
    
    
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) ->
        UITableViewCell! {

            var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "reuseIdentifier")
            }
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell?.textLabel?.text = users[indexPath.row].date + "\n" + String(users[indexPath.row].counter)
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected cell #\(indexPath.row)!")
    }


    @IBAction func done (_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        print("done")
    }

}
