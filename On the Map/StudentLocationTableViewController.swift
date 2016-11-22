//
//  StudentLocationTableViewController.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/21.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class StudentLocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appDelegate: AppDelegate!
    var studentLocations = [StudentLocation]()
    @IBOutlet weak var studentLocationsTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.studentLocations = self.appDelegate.studentLocationDataStructArray
        retrieveDataReloadTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.studentLocationsTableView.reloadData()
    }

    @IBAction func refreshTable(_ sender: Any) {
        retrieveDataReloadTable()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.studentLocationDataStructArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseidentifier = "BasicCellLocationPin"
        let studentLocationArrayItem = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseidentifier) as UITableViewCell!
        
        var firstName: String
        var lastName: String
        
        if let name = studentLocationArrayItem.firstName {
            firstName = name
        } else {
            firstName = "Unknown"
        }
        
        if let last = studentLocationArrayItem.lastName {
            lastName = last
        } else {
            lastName = "Unknown"
        }
        
        cell?.textLabel?.text = "\(firstName) \(lastName)"
        
        return cell!
    }
    
    func retrieveDataReloadTable() {
        ParseClient.sharedInstance().populateStudentLocationStructArray(limitResults: Constants.ParseApiQueryValues.limitNumber){(success, error) in
            performUIUpdatesOnMain {
                if success {
                    self.studentLocations = self.appDelegate.studentLocationDataStructArray
                    self.studentLocationsTableView!.reloadData()
                } else {
                    print(error?.userInfo[NSLocalizedDescriptionKey] as! String)
                }
            }
        }
    }

}
